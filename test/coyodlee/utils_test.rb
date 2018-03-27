require 'test_helper'
require 'coyodlee/utils'

class Coyodlee::UtilsTest < Minitest::Test
  include Coyodlee::Utils

  def setup
    Coyodlee.setup do |config|
      config.host = 'developer.api.yodlee.com'
    end
  end

  def test_uncapitalized_camelize
    assert_equal uncapitalized_camelize('hello_world'), 'helloWorld'
    assert_equal uncapitalized_camelize('hello'), 'hello'
    assert_equal uncapitalized_camelize('one_two_three'), 'oneTwoThree'
  end

  def test_build_uri
    full_uri = build_uri('/restserver/v1/cobrand/login')

    assert_equal full_uri.request_uri,
                 '/restserver/v1/cobrand/login'
    assert_equal full_uri.host,
                 'developer.api.yodlee.com'
    assert_equal full_uri.scheme,
                 'https'
    assert_nil full_uri.query
    assert_equal full_uri.to_s,
                 'https://developer.api.yodlee.com/restserver/v1/cobrand/login'
  end
end
