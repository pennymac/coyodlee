require_relative 'uri_builder'
require_relative 'requests'

module Coyodlee
  class RequestBuilder
    def initialize(uri_builder)
      @uri_builder = uri_builder
    end

    def build(method, resource_path, headers: {}, params: {}, body: nil)
      uri = @uri_builder.build(resource_path)
      http_constructor(method).new(uri).tap do |req|
        add_headers(req, headers)
        req.body = body if body
      end
    end

    private

    def add_headers(req, headers)
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

  class RequestExecutor
    def initialize(facade)
      @facade = facade
    end

    def execute(klass, params={})
      http = @facade.http
      auth = @facade.session_authorization
      request_builder = @facade.request_builder
      req = klass.new(request_builder: request_builder,
                      session_authorization: auth)
              .build(params)
      http.request(req)
    end
  end

  class RequestFacade
    attr_reader :http
    attr_reader :request_builder
    attr_reader :session_authorization

    include Requests

    def initialize(http:, request_builder:, session_authorization: nil)
      @http = http
      @request_builder = request_builder
      @session = session_authorization
    end

    def authorize(session_authorization)
      @session_authorization = session_authorization
    end

    def cobrand_login(login_name:, password:)
      execute(CobrandLoginRequest, login_name: login_name, password: password)
    end

    def user_login(login_name:, password:)
      execute(UserLoginRequest, login_name: login_name, password: password)
    end

    def get_accounts
      execute(GetAccountsRequest)
    end

    private

    def execute(klass, **args)
      RequestExecutor.new(self).execute(klass, args)
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
