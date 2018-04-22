module Coyodlee
  module Facades
    class TransactionsFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def count(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'transactions/count', params: params, headers: headers)
        @request_facade.execute(req)
      end

      def all(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'transactions', params: params, headers: headers)
        @request_facade.execute(req)
      end

      def categorization_rules
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'transactions/categories/rules', headers: headers)
        @request_facade.execute(req)
      end

      def create_categorization_rule(body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:post, 'transactions/categories/rules', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def update_categorization_rule(rule_id:, body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:put, "transactions/categories/rules/#{rule_id}", headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def delete_categorization_rule(rule_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:put, "transactions/categories/rules/#{rule_id}", headers: headers)
        @request_facade.execute(req)
      end

      def run_categorization_rule(rule_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:post, "transactions/categories/rules/#{rule_id}", headers: headers)
        @request_facade.execute(req)
      end

      def run_all_categorization_rules
        params = { 'action' => 'run' }
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:post, 'transactions/categories/rules', headers: headers, params: params)
        @request_facade.execute(req)
      end

      def update(transaction_id:, body: {})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:put, "transactions/#{transaction_id}", headers: headers, body: body)
        @request_facade.execute(req)
      end

      def list_categories
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'transactions/categories', headers: headers)
        @request_facade.execute(req)
      end

      def create_category(body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:post, 'transactions/categories', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def update_category(body:)
        headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
        req = @request_facade.build(:put, 'transactions/categories', headers: headers, body: body.to_json)
        @request_facade.execute(req)
      end

      def delete_category(category_id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:delete, "transactions/categories/#{category_id}", headers: headers)
        @request_facade.execute(req)
      end
    end
  end
end
