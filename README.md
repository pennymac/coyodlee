# Coyodlee
[![Build Status](https://travis-ci.com/pennymac/coyodlee.svg?token=KvBtKQs616ELBMQxp2n7&branch=master)](https://travis-ci.com/pennymac/coyodlee)
[![Maintainability](https://api.codeclimate.com/v1/badges/f36b069069540b196fbd/maintainability)](https://codeclimate.com/github/pennymac/coyodlee/maintainability)
[![Gem Version](https://badge.fury.io/rb/coyodlee.svg)](https://badge.fury.io/rb/coyodlee)

## Status

The software in this repository is in an early alpha state. This repository is currently not accepting pull requests or responding to issues. If there is a bug in the code or a feature you'd like to have, feel free to fork the repository.

## Setup

In sandbox mode, point the ```base_url``` to ```https://developer.api.yodlee.com/ysl/restserver/v1```.

Export the following environment variables:

<table>
  <tr>
    <td><strong>Environment Variables</strong></td>
    <td><strong>Description</td>
  </tr>
  <tr>
    <td>YODLEE_COBRAND_LOGIN</td>
    <td>The Yodlee cobrand login</td>
  <tr/>
  <tr>
    <td>YODLEE_COBRAND_PASSWORD</td>
    <td>The Yodlee cobrand password</td>
  <tr/>
</table>

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

This API exposes a ```setup``` method:

``` ruby
require 'coyodlee'

Coyodlee.setup do |config|
  config.base_url = ENV['YODLEE_BASE_URL']
  config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
  config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
end

require 'coyodlee/sessions'

cob_session = Coyodlee::Sessions::CobrandSession.new
cob_session.login login_name: Coyodlee.cobrand_login, password: Coyodlee.cobrand_password

user_session = Coyodlee::Sessions::UserSession.new(cobrand_session: cob_session)
user_session.login login_name: 'yodlee-test-user-login', password: 'yodlee-test-user-password'

require 'coyodlee/client'

client = Coyodlee::Client.new(user_session)
resp = client.get_accounts

require 'json'

# Print all accounts for the test user
puts JSON.parse(resp.body)
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

