require 'test_helper'
require 'coyodlee/session_tokens'

module Coyodlee
  class SessionTokenTest < Minitest::Test
    def test_session_token_with_no_initial_token
      token = SessionToken.new

      assert_equal token.to_s, ''
    end

    def test_session_token_with_no_initial_token_isnt_present
      token = SessionToken.new

      refute token.present?
    end

    def test_session_token_with_initial_token
      token = SessionToken.new('86420')

      assert_equal token.to_s, '86420'
    end

    def test_session_token_with_initial_token_is_present
      token = SessionToken.new('86420')

      assert token.present?
    end

    def test_null_session_token_always_not_present
      token = NullSessionToken.new

      refute token.present?
    end

    def test_null_session_token_is_empty_string
      token = NullSessionToken.new

      assert_equal token.to_s, ''
    end
  end
end
