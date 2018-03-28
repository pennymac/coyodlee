require 'net/http'
require 'json'

module Coyodlee
  module Requests
    class GetAccountDetailsRequest
      def initialize(request_builder:, session_authorization:)
        @request_builder = request_builder
        @session_authorization = session_authorization
      end

      def build(account_id:, container:)
        @request_builder
          .build(
            :get,
            "accounts/#{account_id}",
            params: {
              container: container
            },
            headers: {
              'Accept' => 'application/json',
              'Authorization' => @session_authorization.to_s
            }
          )
      end
    end

    class GetAccountsRequest
      def initialize(request_builder:, session_authorization:)
        @request_builder = request_builder
        @session_authorization = session_authorization
      end

      def build(_)
        @request_builder
          .build(
            :get,
            'accounts',
            headers: {
              'Accept' => 'application/json',
              'Authorization' => @session_authorization.to_s
            }
          )
      end
    end
  end

  class UserLoginRequest
    def initialize(request_builder:, session_authorization:)
      @request_builder = request_builder
      @session_authorization = session_authorization
    end

    def build(login_name:, password:)
      @request_builder
        .build(
          :post,
          'user/login',
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Authorization' => @session_authorization.to_s
          },
          body: {
            user: {
              loginName: login_name,
              password: password,
              locale: 'en_US'
            }
          }.to_json
        )
    end
  end

  class CobrandLoginRequest
    def initialize(request_builder:, session_authorization: nil)
      @request_builder = request_builder
    end

    def build(login_name:, password:)
      @request_builder
        .build(
          :post,
          'cobrand/login',
          headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
          },
          body: {
            cobrand: {
              cobrandLogin: login_name,
              cobrandPassword: password,
              locale: 'en_US'
            }
          }.to_json
        )
    end
  end
end
