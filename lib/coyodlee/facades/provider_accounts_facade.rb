module Coyodlee
  module Facades
    class ProviderAccountsFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def provider_accounts
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'providerAccounts', headers: headers)
        @request_facade.execute(req)
      end

      def verify(body:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:put, 'providerAccounts/verification', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def verification_status(provider_account_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, "providerAccounts/verification/#{provider_account_id}", headers: headers)
        @request_facade.execute(req)
      end

      def update(body:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:put, 'providerAccounts', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def delete(provider_account_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:delete, "providerAccounts/#{provider_account_id}", headers: headers)
        @request_facade.execute(req)
      end

      def details(provider_account_id:, params: {})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, "providerAccounts/#{provider_account_id}", headers: headers, params: params)
        @request_facade.execute(req)
      end

      def add(provider_id:, body:)
        headers = { 'Accept' => 'application/json' }
        params = { 'providerId' => provider_id }
        req = @request_facade.build(:post, "providerAccounts", headers: headers, params: params, body: body)
        @request_facade.execute(req)
      end
    end
  end
end
