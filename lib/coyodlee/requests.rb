require 'net/http'
require 'json'

module Coyodlee
  module Requests
    class GetAccountsRequest
      def initialize(uri_builder:, session_authorization:)
        @uri_builder = uri_builder
        @session_authorization = session_authorization
      end

      def build(_)
        uri = @uri_builder.build('accounts')
        Net::HTTP::Get.new(uri).tap do |req|
          req['Accept'] = 'application/json'
          req['Authorization'] = @session_authorization.to_s
        end
      end
    end
  end

  class UserLoginRequest
    def initialize(uri_builder:, session_authorization:)
      @uri_builder = uri_builder
      @session_authorization = session_authorization
    end

    def build(login_name:, password:)
      uri = @uri_builder.build('user/login')
      Net::HTTP::Post.new(uri).tap do |req|
        req.body = {
          user: {
            loginName: login_name,
            password: password,
            locale: 'en_US'
          }
        }.to_json
        req['Content-Type'] = 'application/json'
        req['Accept'] = 'application/json'
        req['Authorization'] = @session_authorization.to_s
      end
    end
  end

  class CobrandLoginRequest
    def initialize(uri_builder:, session_authorization: nil)
      @uri_builder = uri_builder
    end

    def build(login_name:, password:)
      uri = @uri_builder.build('cobrand/login')
      Net::HTTP::Post.new(uri).tap do |req|
        req.body = {
          cobrand: {
            cobrandLogin: login_name,
            cobrandPassword: password,
            locale: 'en_US'
          }
        }.to_json
        req['Content-Type'] = 'application/json'
        req['Accept'] = 'application/json'
      end
    end
  end

end
