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

      def register(login_name:, password:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:post, 'user/logout', headers: headers)
        @request_facade.execute(req)
      end

      def unregister
        req = @request_facade.build(:delete, 'user/unregister')
        @request_facade.execute(req)
      end

      def logout(login_name:, password:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:post, 'user/logout', headers: headers)
        @request_facade.execute(req)
      end
    end
  end
end
