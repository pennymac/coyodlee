require 'test_helper'
require 'coyodlee/user_session_token'

module Coyodlee
  class UserSessionTokenTest < Minitest::Test
    def test_user_session_token_with_no_initial_token
      user_session = UserSessionToken.new

      assert_equal user_session.to_s, ''
    end

    def test_user_session_token_with_initial_token
      user_session = UserSessionToken.new('86420')

      assert_equal user_session.to_s, 'userSession=86420'
    end
  end
end
