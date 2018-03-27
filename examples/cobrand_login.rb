require 'coyodlee'
require 'coyodlee/sessions'
require 'dotenv/load'
require 'pry'

Coyodlee.setup do |config|
  config.base_url = 'https://developer.api.yodlee.com/ysl/restserver/v1'
  config.host = 'developer.api.yodlee.com'
  config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
  config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
end

cob_session = Coyodlee::Sessions::CobrandSession.new

resp = cob_session.login login_name: Coyodlee.cobrand_login,
                         password: Coyodlee.cobrand_password

puts resp

