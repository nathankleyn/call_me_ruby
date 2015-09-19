# Call Me Ruby! [![Build Status](https://travis-ci.org/nathankleyn/call_me_ruby.svg?branch=master)](https://travis-ci.org/nathankleyn/call_me_ruby) [![Coverage Status](https://coveralls.io/repos/nathankleyn/call_me_ruby/badge.png?branch=master)](https://coveralls.io/r/nathankleyn/call_me_ruby?branch=master)

Simple, declarative, ActiveModel style callbacks (aka hooks or events) in Ruby!

## Installing

You can install this gem via RubyGems:

```sh
gem install call_me_ruby
```

## Using

Include the mixin in your class and you're away!

Here's how to subscribe to events:

```ruby
require 'call_me_ruby'

class MyAmazingClass
  include CallMeRuby

  # When you do subscribe at the class level like this, it's shared between all instances of this class...
  subscribe :some_event, :will_succeed

  def initialize
    # But if you do subscribe at the instance level like this, it'll only add the callback to this one instance.
    subscribe :some_event, :will_fail
  end

  def will_succeed
    puts 'foo'
  end

  def will_fail
    # If a callback returns false, then no more callbacks will be called and publish will return false. If
    # all callbacks succeed, then publish will return true. Use this to make things fail fast as you need.
    false
  end
end
```

And now you can trigger them:

```ruby
my_amazing_class = MyAmazingClass.new
my_amazing_class.publish(:some_event)
```

## License

The MIT License (MIT)

Copyright (c) 2015 Nathan Kleyn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
