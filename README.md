# Timeouter

[![Gem Version](https://badge.fury.io/rb/timeouter.svg)](https://rubygems.org/gems/timeouter)
[![Gem](https://img.shields.io/gem/dt/timeouter.svg)](https://rubygems.org/gems/timeouter/versions)
[![Test Coverage](https://api.codeclimate.com/v1/badges/4b54466f8f384e3280d8/test_coverage)](https://codeclimate.com/github/RnD-Soft/timeouter/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/4b54466f8f384e3280d8/maintainability)](https://codeclimate.com/github/RnD-Soft/timeouter/maintainability)
[![Quality](https://lysander.x.rnds.pro/api/v1/badges/timeouter_quality.svg)](https://lysander.x.rnds.pro/api/v1/badges/timeouter_quality.html)
[![Outdated](https://lysander.x.rnds.pro/api/v1/badges/timeouter_outdated.svg)](https://lysander.x.rnds.pro/api/v1/badges/timeouter_outdated.html)
[![Vulnerabilities](https://lysander.x.rnds.pro/api/v1/badges/timeouter_vulnerable.svg)](https://lysander.x.rnds.pro/api/v1/badges/timeouter_vulnerable.html)

Timeouter is advisory timeout helper without any background threads.

# Usage

Typical usage scenario:

```ruby
require 'timeouter'

Timeouter::run(3) do |t|
  sleep 1 # do some work

  puts t.elapsed    # 1.00011811
  puts t.left       # 3.99985717 or nil if timeout was 0
  puts t.exhausted? # false or nil if timeout was 0
  puts t.running?   # true
  puts t.running!   # true

  sleep 3 # do another work

  puts t.elapsed    # 4.000177464
  puts t.left       # 0 or nil if timeout was 0
  puts t.exhausted? # true or nil if timeout was 0
  puts t.running?   # false
  puts t.running!   # raise Timeouter::TimeoutError.new('execution expired')
end
```

You can pass exception class and message on creation or on checking:

```ruby
Timeouter::run(1, eclass: RuntimeError, message: 'error') do |t|
  sleep 2
  puts t.running!(eclass: MyError, message: 'myerror')
end
```

Loop helper:

```ruby
# just loop 3 seconds
Timeouter::loop(3) do |t|
  puts "i'am in loop"
  sleep 1
end

# just loop 3 seconds and raise exception then
Timeouter::loop!(3, eclass: MyError) do |t|
  puts "i'am in loop and not raised yet"
  sleep 1
end

# Break the loop after some success and retuel value
result = Timeouter::loop!(3) do |t|
  puts "i'am in loop and not raised yet"
  if t.elapsed > 1
    puts "work done breaking loop"
    break "RESULT"
  end
  sleep 1
end
```

# Installation

It's a gem:
```bash
  gem install timeouter
```
There's also the wonders of [the Gemfile](http://bundler.io):
```ruby
  gem 'timeouter'
```


