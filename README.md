Shellissimo
===========

[![Build Status](https://secure.travis-ci.org/v-yarotsky/shellissimo.png)](http://travis-ci.org/v-yarotsky/shellissimo)
[![Coverage Status](https://coveralls.io/repos/v-yarotsky/shellissimo/badge.png?branch=master)](https://coveralls.io/r/v-yarotsky/shellissimo)
[![Code Climate](https://codeclimate.com/github/v-yarotsky/shellissimo.png)](https://codeclimate.com/github/v-yarotsky/shellissimo)
[![Gem Version](https://badge.fury.io/rb/shellissimo.png)](http://badge.fury.io/rb/shellissimo)

Minimalistic framework for constructing shell-like applications.

Installation
---------------

Add this line to your application's Gemfile:

    gem 'shellissimo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shellissimo

Usage
-----

Create your shell by sublcassing ``Shellissimo::Shell``

```ruby
require 'shellissimo'

class Greeter; def say_hi(name, title); p "hi #{title} #{name}"; end; end

class MyShell < Shellissimo::Shell
  command :hi do |c|
    c.description "Says hello to the user"
    c.mandatory_param(:user) do |p|
      p.description "User name"
      p.validate { |v| !v.to_s.strip.empty? }
    end
    c.param(:title) do |p|
      p.validate { |v| %w(Mr. Ms.).include?(v.to_s) }
    end
    c.run { |params| @greeter.say_hi(params[:user], params[:title]) }
  end

  def initialize
    @greeter = Greeter.new
    super
  end
end

MyShell.new.run
```

In this example help message would look like:

    Available commands:

    hi                               - Says hello to the user
      user                           - User name - mandatory
      title                          - optional

    help (aliases: h)                - Show available commands
    quit (aliases: exit)             - Quit irb

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
