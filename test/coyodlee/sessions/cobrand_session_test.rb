require 'test_helper'
require 'coyodlee/connection'
require 'coyodlee/session'

module Coyodlee
  module Sessions
    class CobrandSessionTest < Minitest::Test
      def setup
        Coyodlee.setup do |config|
          config.host = 'developer.api.yodlee.com'
          config.cobrand_name = 'restserver'
          config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
          config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
        end
      end

      def test_cobrand_successful_login
        conn = Coyodlee::Connection.create

        VCR.use_cassette('cobrand_login_success', allow_playback_repeats: true) do
          conn.start do |api|
            session = Coyodlee::Session.create(api)

            assert api.session_authorization.to_s.empty?

            session.login_cobrand login_name: Coyodlee.cobrand_login,
                                  password: Coyodlee.cobrand_password

            refute api.session_authorization.to_s.empty?
          end
        end
      end
    end
  end
end
