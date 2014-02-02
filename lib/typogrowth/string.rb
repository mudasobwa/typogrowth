# encoding: utf-8

require 'i18n'
require_relative '../typogrowth'

class String
  PUNCTUATION = '¿?¡!()„“”‚‘’«».,:;'.split //

  # Typographyes the string and returns a result
  # See Typogrowth::Parser#parse
  def typo lang: nil, sections: nil
    Typogrowth.parse(self, lang: lang ? lang : is_ru? ? "ru" : I18n.locale, sections: sections)
  end
  # Typographyes the string inplace
  # See Typogrowth::Parser#parse!
  def typo! lang: nil, sections: nil
    Typogrowth.parse!(self, lang: lang ? lang : is_ru? ? "ru" : I18n.locale, sections: sections)
  end

  def is_ru? shadows: []
    Typogrowth.is_ru? self, shadows: shadows
  end

  def defuse elements = nil, shadows: []
    Typogrowth.defuse self, elements || PUNCTUATION, shadows: shadows
  end

end
