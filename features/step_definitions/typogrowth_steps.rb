# encoding: utf-8

Given(/^the input string is "(.*?)"$/) do |str|
  @content = str
end

When(/^input string is processed with Typogrowl’s typography parser$/) do
  @content.gsub! /\\+"/, '"'
  @typo = Typogrowth::Parser.parse @content
end

When(/^input string is processed with Typogrowl’s typography parser with lang "(.*?)"$/) do |lang|
  @content.gsub! /\\+"/, '"'
  @typo = Typogrowth::Parser.parse @content, lang
end

Then(/^neither single nor double quotes are left in the string$/) do
  @typo.scan(/"|'/).count.should == 0
end

Then(/^the typoed result should equal to "(.*?)"$/) do |str|
  @typo.should == str
end
