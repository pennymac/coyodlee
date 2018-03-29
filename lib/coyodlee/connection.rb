require_relative 'uri_builder'
require_relative 'requests'
require 'forwardable'

module Coyodlee
  class RequestBuilder
    def initialize(uri_builder)
      @uri_builder = uri_builder
      @session_authorization = nil
    end

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
      end
    end
  end

  class RequestFacade
    attr_reader :http
    attr_reader :request_builder

    include Requests
    extend Forwardable

    def initialize(http:, request_builder:)
      @http = http
      @request_builder = request_builder
    end

    def_delegators :@request_builder, :authorize

    def cobrand_login(login_name:, password:)
      req = @request_builder
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

    def get_accounts
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'accounts', headers: headers)
      execute(req)
    end

    def get_account_details(account_id:, container:)
      headers = { 'Accept' => 'application/json' }
      params = { container: container }
      req = @request_builder.build(:get, "accounts/#{account_id}", params: params, headers: headers)
      execute(req)
    end

    def get_transactions_count(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions/count', params: params, headers: headers)
      execute(req)
    end

    def get_provider_accounts
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions', headers: headers)
      execute(req)
    end

    def get_transactions(params={})
      headers = { 'Accept' => 'application/json' }
      req = @request_builder.build(:get, 'transactions', params: params, headers: headers)
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
      Net::HTTP.start('developer.api.yodlee.com', use_ssl: true) do |http|
        yield RequestFacade.new(http: http,
                                request_builder: @request_builder)
      end
    end
  end
end
