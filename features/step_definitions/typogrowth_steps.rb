# encoding: utf-8

Given(/^the input string is "(.*?)"$/) do |str|
  @content = str
end

When(/^input string is processed with Typogrowl’s typography parser$/) do
  @content.gsub! /\\+"/, '"'
  @typo = Typogrowth.parse @content
end

When(/^input string is processed with Typogrowl’s typography parser with lang "(.*?)"$/) do |lang|
  @content.gsub! /\\+"/, '"'
  @typo = Typogrowth.parse @content, lang
end

When(/^input string is modified inplace with typo!$/) do
  @typoed = @content.dup
  @typoed.typo!
end

Then(/^neither single nor double quotes are left in the string$/) do
  @typo.scan(/"|'/).count.should == 0
end

Then(/^the typoed result should equal to "(.*?)"$/) do |str|
  @typo.should == str
end

Then(/^the call to string’s typo should equal to "(.*?)"$/) do |str|
  @content.typo.should == str
end

Then(/^the call to string’s typo with lang "(.*?)" should equal to "(.*?)"$/) do |lang, str|
  @content.typo('ru').should == str
end

Then(/^typoed result should equal to "(.*?)"$/) do |str|
  @typoed.should == str
end
