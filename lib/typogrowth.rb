# encoding: utf-8

require 'yaml'

require 'uri'
require 'base64'
require_relative 'typogrowth/version'
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
    attr_reader :yaml
    
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
    def self.merge custom
      instance.yaml.rmerge!(custom)
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
    def self.parse! str, lang = :default
      str.gsub!(URI.regexp) { |m| "⚓#{Base64.encode64 m}⚓" }
      lang = lang.to_sym
      instance.yaml.each { |k, values|
        values.each { |k, v|
          if !!v[:re]
            v[lang] = v[:default] if (!v[lang] || v[lang].size.zero?)
            raise MalformedRulesFile.new "Malformed rules file (no subst for #{v})" \
              if !v[lang] || v[lang].size.zero?
            substituted = !!v[:pattern] ?
                str.gsub!(/#{v[:re]}/) { |m| m.gsub(/#{v[:pattern]}/, v[lang].first) } :
                str.gsub!(/#{v[:re]}/, v[lang].first)
            # logger.warn "Unsafe substitutions were made to source:\n# ⇒ #{str}"\
            #  if v[:alert] && substituted
            if v[lang].size > 1
              str.gsub!(/#{v[lang].first}/) { |m|
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
      str.gsub!(/⚓(.*)⚓/m) { |m| Base64.decode64 m }
      str
    end

    # Out-of-place version of `String` typographing. See #parse!
    def self.parse str, lang = :default
      self.parse! str.dup, lang
    end
  private
    DEFAULT_SET = 'typogrowth'
    ENTITIES = %w{re}
    
    def initialize file
      @yaml = YAML.load_file "#{File.dirname(__FILE__)}/config/#{file}.yaml"
      @yaml.delete(:placeholder)
    end

    @@instance = Parser.new(DEFAULT_SET)
    
    def self.instance 
      @@instance
    end
        
    private_class_method :new  
  end
end

