require_relative 'uri_builder'
require 'forwardable'
require 'net/http'

module Coyodlee
  class RequestBuilder
    extend Forwardable

    def initialize(uri_builder)
      @uri_builder = uri_builder
      @session_authorization = nil
    end

    def_delegators :@uri_builder, :host

    def authorize(session_authorization)
      @session_authorization = session_authorization
    end

    def build(method, resource_path, headers: {}, params: {}, body: nil)
      q = params.empty? ? nil : build_query(params)
      uri = @uri_builder.build(resource_path, query: q)
      http_constructor(method).new(uri).tap do |req|
        add_headers(req, headers)
        req.body = body if body
      end
    end

    private

    def build_query(params)
      params
        .to_a
        .map { |keyval| keyval.join('=') }
        .join('&')
    end

    def add_headers(req, headers)
      if @session_authorization
        headers['Authorization'] = @session_authorization.to_s
      end

      headers.each do |key, value|
        req[key] = value
      end
    end

    def http_constructor(method)
      case method
      when :get
        Net::HTTP::Get
      when :post
        Net::HTTP::Post
      when :put
        Net::HTTP::Put
      when :delete
        Net::HTTP::Delet
      end
    end
  end

  class RequestFacade
    attr_reader :http
    attr_reader :request_builder

    extend Forwardable

    def initialize(http:, request_builder:)
      @http = http
      @request_builder = request_builder
    end

    def_delegators :@request_builder, :authorize

    def cobrand_login(login_name:, password:)
      body = {
        cobrand: {
          cobrandLogin: login_name,
          cobrandPassword: password,
          locale: 'en_US'
        }
      }.to_json
      headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      req = @request_builder.build(:post, 'cobrand/login', headers: headers, body: body)
      execute(req)
    end

    def user_login(login_name:, password:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      body = {
        user: {
          loginName: login_name,
          password: password,
          locale: 'en_US'
        }
      }.to_json
      req = @request_builder.build(:post, 'user/login', headers: headers, body: body)
      execute(req)
    end

    def accounts
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'accounts', headers: headers)
      execute(req)
    end

    def account_details(account_id:, container:)
      headers = { 'Accept' => 'application/json' }
      params = { container: container }
      req = @request_builder.build(:get, "accounts/#{account_id}", params: params, headers: headers)
      execute(req)
    end

    def transactions_count(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions/count', params: params, headers: headers)
      execute(req)
    end

    def provider_accounts
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'providerAccounts', headers: headers)
      execute(req)
    end

    def update_account(account_id:, body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:put, "accounts/#{account_id}", headers: headers, body: body.to_json)
      execute(req)
    end

    def delete_account(account_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:delete, "accounts/#{account_id}", headers: headers)
      execute(req)
    end

    def add_manual_account(body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:post, 'accounts', headers: headers, body: body.to_json)
      execute(req)
    end

    def investment_options(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'accounts/investmentPlan/investmentOptions', headers: headers, params: params)
      execute(req)
    end

    def historical_balances(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'accounts/historicalBalances', headers: headers, params: params)
      execute(req)
    end

    def holdings(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'holdings', headers: headers, params: params)
      execute(req)
    end

    def extended_securities_info(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'holdings/securities', headers: headers, params: params)
      execute(req)
    end

    def holding_type_list
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'holdings/holdingTypeList', headers: headers)
      execute(req)
    end

    def asset_classification_list
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'holdings/assetClassificationList', headers: headers)
      execute(req)
    end

    def providers(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, "providers", headers: headers, params: params)
      execute(req)
    end

    def verify_provider_account(body:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:put, 'providerAccounts/verification', headers: headers, body: body.to_json)
      execute(req)
    end

    def verification_status(provider_account_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, "providerAccounts/verification/#{provider_account_id}", headers: headers)
      execute(req)
    end

    def update_provider_account(body:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:put, 'providerAccounts', headers: headers, body: body.to_json)
      execute(req)
    end

    def delete_provider_account(provider_account_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:delete, "providerAccounts/#{provider_account_id}", headers: headers)
      execute(req)
    end

    def provider_account_details(provider_account_id:, params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, "providerAccounts/#{provider_account_id}", headers: headers, params: params)
      execute(req)
    end

    def add_provider_account(provider_id:, body:)
      headers = { 'Accept' => 'application/json' }
      params = { 'providerId' => provider_id }
      req = @request_builder.build(:post, "providerAccounts", headers: headers, params: params, body: body)
      execute(req)
    end

    def provider_details(provider_id:, provider_account_id:)
      headers = { 'Accept' => 'application/json' }
      params = { 'providerAccountId' => provider_account_id }
      req = @request_builder.build(:get, "providers/#{provider_id}", headers: headers, params: params)
      execute(req)
    end

    def transactions(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions', params: params, headers: headers)
      execute(req)
    end

    def transaction_categorization_rules
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions/categories/rules', headers: headers)
      execute(req)
    end

    def create_transaction_categorization_rule(body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:post, 'transactions/categories/rules', headers: headers, body: body.to_json)
      execute(req)
    end

    def update_transaction_categorization_rule(rule_id:, body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:put, "transactions/categories/rules/#{rule_id}", headers: headers, body: body.to_json)
      execute(req)
    end

    def delete_transaction_categorization_rule(rule_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:put, "transactions/categories/rules/#{rule_id}", headers: headers)
      execute(req)
    end

    def run_transaction_categorization_rule(rule_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:post, "transactions/categories/rules/#{rule_id}", headers: headers)
      execute(req)
    end

    def run_all_transaction_categorization_rules
      params = { 'action' => 'run' }
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:post, 'transactions/categories/rules', headers: headers, params: params)
      execute(req)
    end

    def delete_transaction_category(category_id:)
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:delete, "transactions/categories/#{category_id}", headers: headers)
      execute(req)
    end

    def update_transaction_category(category_id:, params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:put, "transactions/categories/#{category_id}", headers: headers, params: params)
      execute(req)
    end

    def transaction_category_list
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions/categories', headers: headers)
      execute(req)
    end

    def create_category(body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:post, 'transactions/categories', headers: headers, body: body.to_json)
      execute(req)
    end

    def update_category(body:)
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      req = @request_builder.build(:put, 'transactions/categories', headers: headers, body: body.to_json)
      execute(req)
    end

    def transactions(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions', headers: headers, params: params)
      execute(req)
    end

    def statements(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'statements', headers: headers, params: params)
      execute(req)
    end

    def transaction_summary(group_by:, params={})
      params['groupBy'] = group_by
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'derived/transactionSummary', headers: headers, params: params)
      execute(req)
    end

    def holding_summary(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'derived/holdingSummary', headers: headers, params: params)
      execute(req)
    end

    def networth_summary(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'derived/networth', headers: headers, params: params)
      execute(req)
    end

    def extract_events(event_name:, from_date:, to_date:)
      params = {
        'eventName' => event_name,
        'fromDate' => fromDate,
        'toDate' => toDate
      }
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'dataExtracts/events', headers: headers, params: params)
      execute(req)
    end

    def user_data(login_name:, from_date:, to_date:)
      params = {
        'loginName' => login_name,
        'fromDate' => fromDate,
        'toDate' => toDate
      }
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'dataExtracts/userData', headers: headers, params: params)
      execute(req)
    end

    private

    def execute(req)
      http.request(req)
    end
  end

  class Connection
    class << self
      def create
        new RequestBuilder.new(UriBuilder.new(host: Coyodlee.host))
      end
    end

    def initialize(request_builder)
      @request_builder = request_builder
    end

    def start(&block)
      Net::HTTP.start(@request_builder.host, use_ssl: true) do |http|
        yield RequestFacade.new(http: http,
                                request_builder: @request_builder)
      end
    end
  end
end
