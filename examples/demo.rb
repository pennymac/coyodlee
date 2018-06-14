require 'coyodlee'
require 'coyodlee/connection'
require 'coyodlee/messages'
require 'coyodlee/session'
require 'dotenv/load'
require 'pry'

Coyodlee.setup do |config|
  config.host = 'developer.api.yodlee.com'
  config.cobrand_name = 'restserver'
  config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
  config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
end

conn = Coyodlee::Connection.create

resp = conn.start do |api|
  session = Coyodlee::Session.create(api)
  session.login_cobrand login_name: Coyodlee.cobrand_login,
                        password: Coyodlee.cobrand_password
  session.login_user login_name: ENV['YODLEE_USER_1_LOGIN_NAME'],
                     password: ENV['YODLEE_USER_1_PASSWORD']
end

puts resp
