# encoding: utf-8

require 'i18n'
require 'base64'
require_relative '../typogrowth'

class String
  PUNCTUATION = '¿?¡!()„“”‚‘’«».,:;'.split //

  # Typographyes the string and returns a result
  # See Typogrowth::Parser#parse
  def typo lang: nil, sections: nil, shadows: nil
    Typogrowth.parse(
      self,
      lang: lang ? lang : is_ru? ? "ru" : I18n.locale,
      shadows: shadows,
      sections: sections
    )
  end
  # Typographyes the string inplace
  # See Typogrowth::Parser#parse!
  def typo! lang: nil, sections: nil, shadows: nil
    Typogrowth.parse!(
      self,
      lang: lang ? lang : is_ru? ? "ru" : I18n.locale,
      shadows: shadows,
      sections: sections
    )
  end

  def is_ru? shadows: []
    Typogrowth.is_ru? self, shadows: shadows
  end

  def defuse elements = nil, shadows: []
    Typogrowth.defuse self, elements || PUNCTUATION, shadows: shadows
  end

  def psub pattern, exclusion, replacement
    delims = self.safe_delimiters
    s = self.dup
    [*exclusion].each { |re|
      re = /#{re}/ unless Regexp === re
      s.gsub!(re) { |m| "#{delims.first}#{Base64.encode64 m}#{delims.last}" }
    }
    s.gsub! pattern, replacement
    s.gsub!(/#{delims.first}(.*?)#{delims.last}/m) { |m|
      Base64.decode64(m).force_encoding('UTF-8')
    }
    s
  end

# private

  def safe_delimiters
    delimiters = ['❮', '❯']
    loop do
      break delimiters unless self.match(/#{delimiters.join('|')}/)
      delimiters.map! {|d| d*2}
    end
  end

end
