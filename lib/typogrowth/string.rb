# encoding: utf-8

require 'i18n'
require_relative '../typogrowth'

class String
  # Typographyes the string and returns a result
  # See Typogrowth::Parser#parse
  def typo lang = nil
    Typogrowth::Parser.parse(self, lang: lang ? lang : I18n.locale)
  end
  # Typographyes the string inplace
  # See Typogrowth::Parser#parse!
  def typo! lang = nil
    Typogrowth::Parser.parse!(self, lang: lang ? lang : I18n.locale)
  end
end
