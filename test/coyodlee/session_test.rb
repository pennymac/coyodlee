require 'test_helper'
require 'coyodlee/session'
require 'coyodlee/cobrand_session'
require 'coyodlee/user_session'
require 'pry'

module Coyodlee
  class SessionTest < Minitest::Test
    def test_empty_session
      empty_session = Session.new

      assert_equal empty_session.to_s, ''
    end

    def test_session_with_cobrand_session
      cob_session = CobrandSession.new('13579')
      session = Session.new(cobrand_session: cob_session)

      assert_equal session.to_s, 'cobSession=13579'
    end

    def test_session_with_cobrand_and_user_session
      cob_session = CobrandSession.new('13579')
      user_session = UserSession.new('24680')
      session = Session.new(cobrand_session: cob_session, user_session: user_session)

      assert_equal session.to_s, 'cobSession=13579,userSession=24680'
    end
  end
end
