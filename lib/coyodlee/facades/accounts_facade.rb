module Coyodlee
  module Facades
    class AccountsFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def all
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'accounts', headers: headers)
        @request_facade.execute(req)
      end

      def details(account_id:, container:)
        headers = { 'Accept' => 'application/json' }
        params = { 'container' => container }
        req = @request_facade.build(:get, "accounts/#{account_id}", params: params, headers: headers)
        @request_facade.execute(req)
      end

      def update(account_id:, body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:put, "accounts/#{account_id}", headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def delete(account_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:delete, "accounts/#{account_id}", headers: headers)
        @request_facade.execute(req)
      end

      def add_manually(body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:post, 'accounts', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def investment_options(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'accounts/investmentPlan/investmentOptions', headers: headers, params: params)
        @request_facade.execute(req)
      end

      def historical_balances(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'accounts/historicalBalances', headers: headers, params: params)
        @request_facade.execute(req)
      end
    end
  end
end
