# encoding: utf-8

require 'yaml'

require 'uri'
require 'base64'
require_relative 'typogrowth/version'
require_relative 'typogrowth/string'
require_relative 'utils/hash_recursive_merge'

#
# = String typographing with language support.
#
# Parses and corrects the typography in strings. It supports
# different language rules and user rules customization.
#
# The package also monkeypatches `String` class with both
# `typo` and `typo!` methods.
#
# Category::    Ruby
# Author::      Alexei Matyushkin <am@mudasobwa.ru>
# Copyright::   2013 The Authors
# License::     MIT License
# Link::        http://rocket-science.ru/
# Source::      http://github.com/mudasobwa/typogrowth
#
module Typogrowth
  # Internal exception class just to make the exception distinction possible
  class MalformedRulesFile < Exception ; end

  # Parses and corrects the typography in strings. It supports
  # different language rules and easy user rules customization.
  class Parser
    attr_reader :yaml, :shadows

    def self.safe_delimiters str
      delimiters = ['❮', '❯']
      loop do
        break delimiters unless str.match(/#{delimiters.join('|')}/)
        delimiters.map! {|d| d*2}
      end
    end

    #
    # Recursively merges the initial settings with custom.
    #
    # To supply your own rules to processing:
    #
    # - create a +hash+ of additional rules in the same form as in the
    # standard `typogrowth.yaml` file shipped with a project
    # - merge the hash with the standard one using this function
    #
    # For instance, to add french rules one is to merge in the following yaml:
    #
    #     :quotes :
    #       :punctuation :
    #         :fr : "\\k<quote>\\k<punct>"
    #     …
    #
    def merge custom
      yaml.rmerge!(custom)
    end

    #
    # Inplace version of string typographying.
    #
    # Retrieves the string and changes all the typewriters quotes (doubles
    # and sigles), to inches, minutes, seconds, proper quotation signs.
    #
    # While the input strings are e.g.
    #
    #     And God said "Baz heard "Bar" once" , and there was light.
    #     That's a 6.3" man, he sees sunsets at 10°20'30" E.
    #
    # It will produce:
    #
    #     And God said “Baz heard ‘Bar’ once,” and there was light.
    #     That’s a 6.3″ man, he sees sunsets at 10°20′30″ E.
    #
    # The utility also handles dashes as well.
    #
    # @param str [String] the string to be typographyed inplace
    # @param lang the language to use rules for
    #
    def parse str, lang: :default, shadows: []
      lang = lang.to_sym
      delims = Parser.safe_delimiters str
      str.split(/\R{2,}/).map { |para|
        @shadows.concat([*shadows]).uniq.each { |re|
          para.gsub!(re) { |m| "#{delims.first}#{Base64.encode64 m}#{delims.last}" }
        }
        @yaml.each { |key, values|
          values.each { |k, v|
            if !!v[:re]
              v[lang] = v[:default] if (!v[lang] || v[lang].size.zero?)
              raise MalformedRulesFile.new "Malformed rules file (no subst for #{v})" \
                if !v[lang] || v[lang].size.zero?
              substituted = !!v[:pattern] ?
                  para.gsub!(/#{v[:re]}/) { |m| m.gsub(/#{v[:pattern]}/, v[lang].first) } :
                  para.gsub!(/#{v[:re]}/, v[lang].first)
              # logger.warn "Unsafe substitutions were made to source:\n# ⇒ #{para}"\
              #  if v[:alert] && substituted
              if v[lang].size > 1
                para.gsub!(/#{v[lang].first}/) { |m|
                  prev = $`
                  obsoletes = prev.count(v[lang].join)
                  compliants = values[v[:compliant].to_sym][lang] ||
                               values[v[:compliant].to_sym][:default]
                  obsoletes -= prev.count(compliants.join) \
                    if !!v[:compliant]
                  !!v[:slave] ?
                    obsoletes -= prev.count(v[:original]) + 1 :
                    obsoletes += prev.count(v[:original])

                  v[lang][obsoletes % v[lang].size]
                }
              end
            end
          }
        }
        para
      }.join(%Q(

))
      .gsub(/#{delims.first}(.*?)#{delims.last}/m) { |m|
        Base64.decode64(m).force_encoding('UTF-8')
      }
    end

    def is_ru? str, shadows: []
      clean = @shadows.concat([*shadows]).uniq.inject(str) { |memo, re|
        memo.gsub(re, '')
      }
      clean.scan(/[А-Яа-я]/).size > clean.length / 3
    end

    def add_shadows re
      @shadows.concat [*re]
    end

    def del_shadows re
      @shadows.delete_if { |stored| [*re].include? stored }
    end

    # Out-of-place version of `String` typographing. See #parse!
    def self.parse str, lang: :default, shadows: []
      Parser.new.parse str, lang: lang, shadows: shadows
    end

    # Out-of-place version of `String` typographing. See #parse!
    def self.parse! str, lang: :default, shadows: []
      str.replace self.parse str, lang: lang, shadows: shadows
    end

    # Out-of-place version of `String` typographing. See #parse!
    def self.is_ru? str, shadows: []
      Parser.new.is_ru? str, shadows: shadows
    end

    DEFAULT_SET = 'typogrowth'
    HTML_TAG_RE = /<[^>]*>/

    def initialize file = nil
      file = DEFAULT_SET unless file
      @yaml = YAML.load_file "#{File.dirname(__FILE__)}/config/#{file}.yaml"
      @yaml.delete(:placeholder)
      @shadows = [HTML_TAG_RE, URI.regexp(['ftp', 'http', 'https', 'mailto'])]
    end

  end

  def self.parse str, lang: :default, shadows: []
    Parser.parse str, lang: lang, shadows: shadows
  end

  def self.parse! str, lang: :default, shadows: []
    Parser.parse! str, lang: lang, shadows: shadows
  end

  def self.is_ru? str, shadows: []
    Parser.is_ru? str, shadows: shadows
  end
end

