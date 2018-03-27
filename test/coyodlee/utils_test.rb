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
end
