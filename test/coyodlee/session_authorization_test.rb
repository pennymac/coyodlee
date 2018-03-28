require 'test_helper'
require 'coyodlee/session_authorization'
require 'coyodlee/cobrand_session_token'
require 'coyodlee/user_session_token'
require 'pry'

module Coyodlee
  class SessionAuthorizationTest < Minitest::Test
    def test_empty_session
      auth = SessionAuthorization.new

      assert_equal auth.to_s, ''
    end

    def test_session_with_cobrand_session
      cob_session_token = CobrandSessionToken.new('13579')
      auth = SessionAuthorization.new(cobrand_session_token: cob_session_token)

      assert_equal auth.to_s, 'cobSession=13579'
    end

    def test_session_with_cobrand_and_user_session
      cob_session_token = CobrandSessionToken.new('13579')
      user_session_token = UserSessionToken.new('24680')
      auth = SessionAuthorization.new(cobrand_session_token: cob_session_token, user_session_token: user_session_token)

      assert_equal auth.to_s, 'cobSession=13579,userSession=24680'
    end
  end
end
