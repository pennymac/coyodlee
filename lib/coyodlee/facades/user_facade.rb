module Coyodlee
  module Facades
    class UserFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def login(login_name:, password:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        body = {
          user: {
            loginName: login_name,
            password: password,
            locale: 'en_US'
          }
        }.to_json
        req = @request_facade.build(:post, 'user/login', headers: headers, body: body)
        @request_facade.execute(req)
      end

      def access_tokens(app_ids:)
        headers = { 'Accept' => 'application/json' }
        params = { 'appIds' => app_ids }
        req = @request_facade.build(:get, 'user/accessTokens', params: params, headers: headers)
        @request_facade.execute(req)
      end

      def register(login_name:, password:, email:, user: {})
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        body = {
          user: {
            loginName: login_name,
            password: password,
            email: email
          }.merge(user)
        }.to_json
        req = @request_facade.build(:post, 'user/register', headers: headers, body: body)
        @request_facade.execute(req)
      end

      def unregister
        req = @request_facade.build(:delete, 'user/unregister')
        @request_facade.execute(req)
      end

      def details
        req = @request_facade.build(:get, 'user')
        @request_facade.execute(req)
      end

      def logout
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:post, 'user/logout', headers: headers)
        @request_facade.execute(req)
      end
    end
  end
end
