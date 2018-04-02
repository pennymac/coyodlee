require 'test_helper'
require 'coyodlee/connection'
require 'coyodlee/session'

module Coyodlee
  module Sessions
    class UserSessionTest < Minitest::Test
      def setup
        Coyodlee.setup do |config|
          config.host = 'developer.api.yodlee.com'
          config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
          config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
        end
      end

      def test_user_login_success
        login_name = ENV['YODLEE_USER_1_LOGIN_NAME']
        password = ENV['YODLEE_USER_1_PASSWORD']
        conn = Coyodlee::Connection.create

        conn.start do |api|
          session = Coyodlee::Session.create(api)

          assert session.authorization.to_s.empty?

          VCR.use_cassette('cobrand_login_success', allow_playback_repeats: true) do
            session.login_cobrand login_name: Coyodlee.cobrand_login,
                                  password: Coyodlee.cobrand_password
          end

          VCR.use_cassette('user_login_success', allow_playback_repeats: true) do
            session.login_user login_name: login_name,
                               password: password
          end

          refute session.authorization.to_s.empty?
        end
      end
    end
  end
end
