require 'test_helper'
require 'coyodlee/session_tokens'

module Coyodlee
  class CobrandSessionTokenTest < Minitest::Test
    def test_cobrand_session_no_token
      cob_session = CobrandSessionToken.new

      assert_equal cob_session.to_s, ''
    end

    def test_cobrand_session_with_token
      cob_session = CobrandSessionToken.new('13579')

      assert_equal cob_session.to_s, 'cobSession=13579'
    end
  end
end
