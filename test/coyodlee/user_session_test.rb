require 'test_helper'
require 'coyodlee/user_session'

module Coyodlee
  class UserSessionTest < Minitest::Test
    def test_user_session_no_token
      user_session = UserSession.new

      assert_equal user_session.to_s, ''
    end

    def test_user_session_with_token
      user_session = UserSession.new('86420')

      assert_equal user_session.to_s, 'userSession=86420'
    end
  end
end
