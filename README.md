# Typogrowth

[![Build Status](https://travis-ci.org/mudasobwa/typogrowth.png)](https://travis-ci.org/mudasobwa/typogrowth)
[![Gemnasium](https://gemnasium.com/mudasobwa/typogrowth.png?travis)](https://gemnasium.com/mudasobwa/typogrowth)

Typogrowth is the simple gem, providing easy way to make string
typographically correct. It introduce the class method:

```ruby
    Typogrowth.parse string, lang = nil
```

as well as it monkeypatches `String` class with `typo` method.
If language is omitted, it uses `I18n.locale`. Also `:default`
may be specified as language setting (which is english, in fact.)

To modify the succession of quotation signs (as well as all the 
others options,) feel free to change `config/typogrowth.yaml`. 

## Installation

Add this line to your application's Gemfile:

    gem 'typogrowth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typogrowth

## Usage

```ruby
s = 'And God said "Baz heard "Bar" once" , and there was light.'
puts s.typo
# ⇒ And God said “Baz heard ‘Bar’ once,” and there was light.
puts Typogrowth.parse(s)
# ⇒ And God said “Baz heard ‘Bar’ once,” and there was light.

s = 'И Бог сказал: "Я - слышу "Бум" и "Бам" где-то там" , и стало светло.'
puts s.typo('ru')  # Explicit locale specification may be omitted
                   #       while running under ru_RU.UTF-8 locale
# ⇒ И Бог сказал: «Я — слышу „Бум“ и „Бам“ где-то там», и стало светло.

s = 'And God said "Oslo coordinates are: 59°57′N 10°45′E" and there was light.'
s.typo!
# ⇒ And God said “Oslo coordinates are: 59°57′N 10°45′E” and there was light.
puts s 
# ⇒ And God said “Oslo coordinates are: 59°57′N 10°45′E” and there was light.
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
