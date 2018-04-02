require 'test_helper'
require 'coyodlee/uri_builder'

module Coyodlee
  class UriBuilderTest < Minitest::Test
    def test_uri_builder
      uri_builder = UriBuilder.new(host: 'developer.api.yodlee.com')
      full_uri = uri_builder.build('/cobrand/login')

      assert_equal full_uri.request_uri,
                   '/ysl/restserver/v1/cobrand/login'
      assert_equal full_uri.host,
                   'developer.api.yodlee.com'
      assert_equal full_uri.scheme,
                   'https'
      assert_nil full_uri.query
      assert_equal full_uri.to_s,
                   'https://developer.api.yodlee.com/ysl/restserver/v1/cobrand/login'
    end
  end
end
