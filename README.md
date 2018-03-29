# Coyodlee
[![Build Status](https://travis-ci.com/pennymac/coyodlee.svg?token=KvBtKQs616ELBMQxp2n7&branch=master)](https://travis-ci.com/pennymac/coyodlee)
[![Maintainability](https://api.codeclimate.com/v1/badges/f36b069069540b196fbd/maintainability)](https://codeclimate.com/github/pennymac/coyodlee/maintainability)
[![Gem Version](https://badge.fury.io/rb/coyodlee.svg)](https://badge.fury.io/rb/coyodlee)

## Status

The software in this repository is in an early alpha state. This repository is currently not accepting pull requests or responding to issues. If there is a bug in the code or a feature you'd like to have, feel free to fork the repository.

## Setup

In sandbox mode, point the ```base_url``` to ```https://developer.api.yodlee.com/ysl/restserver/v1```.

Export the following environment variables:

| Environment Variable      | Description                           |
|---------------------------|---------------------------------------|
| YODLEE\_COBRAND\_LOGIN    | The login of your assigned cobrand    |
| YODLEE\_COBRAND\_PASSWORD | The password of your assigned cobrand |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coyodlee'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coyodlee

## Usage

The API remains in flux. Here is the current way to interact with Yodlee:

``` ruby
require 'coyodlee'

Coyodlee.setup do |config|
  config.host = 'developer.api.yodlee.com'
  config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
  config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
end

require 'coyodlee/connection'
require 'coyodlee/session'

conn = Coyodlee::Connection.create

resp = conn.start do |api|
  session = Coyodlee::Session.create(api)
  session.cobrand_login login_name: Coyodlee.cobrand_login,
                        password: Coyodlee.cobrand_password
  session.user_login login_name: ENV['YODLEE_USER_1_LOGIN_NAME'],
                     password: ENV['YODLEE_USER_1_PASSWORD']

  api.get_accounts
end

puts resp
```

## Testing

To run tests: ```bundle exec rake test```.

All tests are written in Minitest and HTTP requests are recorded using VCR.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Why another Yodlee Ruby library?

* This library supports Yodlee's newer RESTful API. [yodlee-icious](https://github.com/liftforward/yodlee-icious) supports the older RESTful wrapper over the SOAP API.
* This library aims to be comprehensive in its feature set. [yodlee](https://github.com/aasmith/yodlee) only supports retrieving data from Yodlee MoneyCenter.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pennymac/coyodlee. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

