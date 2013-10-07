# Typogrowth

Typogrowth is the simple gem, providing easy way to make string
typographically correct. It introduce the class method:

    Typogrowth::Parser.parse string, lang = nil

as well as it monkeypatches `String` class with `typo` method.
If language is omitted, it uses `I18n.locale`. Also `:default`
may be specified as language setting (which is english, in fact.)

## Installation

Add this line to your application's Gemfile:

    gem 'typogrowth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typogrowth

## Usage

    s = 'And God said "Baz heard "Bar" once" , and there was light.'
    puts s.typo
    # ⇒ And God said “Baz heard ‘Bar’ once,” and there was light.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
