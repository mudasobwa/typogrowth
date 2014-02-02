# encoding: utf-8

require 'i18n'
require_relative '../typogrowth'

class String
  # Typographyes the string and returns a result
  # See Typogrowth::Parser#parse
  def typo lang = nil
    Typogrowth.parse(self, lang: lang ? lang : is_ru? ? "ru" : I18n.locale)
  end
  # Typographyes the string inplace
  # See Typogrowth::Parser#parse!
  def typo! lang = nil
    Typogrowth.parse!(self, lang: lang ? lang : is_ru? ? "ru" : I18n.locale)
  end

  def is_ru? shadows = []
    Typogrowth.is_ru? self, shadows: shadows
  end
end
