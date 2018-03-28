require 'coyodlee'
require 'coyodlee/connection'
require 'dotenv/load'
require 'pry'

Coyodlee.setup do |config|
  config.base_url = 'https://developer.api.yodlee.com/ysl/restserver/v1'
  config.host = 'developer.api.yodlee.com'
  config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
  config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
end

conn = Coyodlee::Connection.create

resp = conn.start do |api|
  api.cobrand_login login_name: Coyodlee.cobrand_login,
                    password: Coyodlee.cobrand_password
end

byebug

puts resp

