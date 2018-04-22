require_relative 'uri_builder'
require_relative 'facades'
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
        Net::HTTP::Delete
      end
    end
  end

  class RequestFacade
    attr_reader :http
    attr_reader :request_builder

    extend Forwardable
    include Facades

    def initialize(http:, request_builder:)
      @http = http
      @request_builder = request_builder
      @user_facade = UserFacade.new(self)
      @cobrand_facade = CobrandFacade.new(self)
      @accounts_facade = AccountsFacade.new(self)
      @transactions_facade = TransactionsFacade.new(self)
      @holdings_facade = HoldingsFacade.new(self)
      @provider_accounts_facade = ProviderAccountsFacade.new(self)
    end

    def_delegators :@request_builder, :authorize, :build

    def_delegator :@user_facade, :login, :login_user
    def_delegator :@user_facade, :logout, :logout_user
    def_delegator :@user_facade, :register, :register_user
    def_delegator :@user_facade, :unregister, :unregister_user

    def_delegator :@cobrand_facade, :login, :login_cobrand
    def_delegator :@cobrand_facade, :logout, :logout_cobrand
    def_delegator :@cobrand_facade, :public_key, :cobrand_public_key

    def_delegator :@accounts_facade, :all, :accounts
    def_delegator :@accounts_facade, :details, :account_details
    def_delegator :@accounts_facade, :update, :update_account
    def_delegator :@accounts_facade, :delete, :delete_account
    def_delegator :@accounts_facade, :add_manually, :add_manual_account
    def_delegator :@accounts_facade, :investment_options, :investment_options
    def_delegator :@accounts_facade, :historical_balances, :historical_balances

    def_delegator :@holdings_facade, :all, :holdings
    def_delegators :@holdings_facade, :extended_securities_info, :holding_type_list, :asset_classification_list

    def_delegator :@transactions_facade, :count, :transactions_count
    def_delegator :@transactions_facade, :all, :transactions
    def_delegator :@transactions_facade, :categorization_rules, :transaction_categorization_rules
    def_delegator :@transactions_facade, :create_categorization_rule, :create_transaction_categorization_rule
    def_delegator :@transactions_facade, :update_categorization_rule, :update_transaction_categorization_rule
    def_delegator :@transactions_facade, :delete_categorization_rule, :delete_transaction_categorization_rule
    def_delegator :@transactions_facade, :run_categorization_rule, :run_transaction_categorization_rule
    def_delegator :@transactions_facade, :run_all_categorization_rule, :run_all_transaction_categorization_rule
    def_delegator :@transactions_facade, :update, :update_transaction
    def_delegator :@transactions_facade, :list_categories, :transaction_categories
    def_delegator :@transactions_facade, :create_category, :create_transaction_category
    def_delegator :@transactions_facade, :update_category, :update_transaction_category
    def_delegator :@transactions_facade, :delete_category, :delete_transaction_category

    def_delegator :@provider_accounts_facade, :add, :add_provider_account
    def_delegator :@provider_accounts_facade, :details, :provider_account_details
    def_delegator :@provider_accounts_facade, :delete, :delete_provider_account
    def_delegator :@provider_accounts_facade, :update, :update_provider_account
    def_delegator :@provider_accounts_facade, :verify, :verify_provider_account
    def_delegator :@provider_accounts_facade, :verification_status, :provider_account_verification_status

    def providers(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, "providers", headers: headers, params: params)
      execute(req)
    end

    def provider_details(provider_id:, provider_account_id:)
      headers = { 'Accept' => 'application/json' }
      params = { 'providerAccountId' => provider_account_id }
      req = @request_builder.build(:get, "providers/#{provider_id}", headers: headers, params: params)
      execute(req)
    end

    def statements(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'statements', headers: headers, params: params)
      execute(req)
    end

    def transaction_summary(group_by:, params: {})
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
