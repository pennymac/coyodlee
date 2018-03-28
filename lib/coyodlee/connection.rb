require_relative 'uri_builder'
require_relative 'requests'

module Coyodlee
  class RequestExecutor
    def initialize(facade)
      @facade = facade
    end

    def execute(klass, params={})
      uri_builder = @facade.uri_builder
      http = @facade.http
      auth = @facade.session_authorization
      req = klass.new(uri_builder: uri_builder,
                      session_authorization: auth)
              .build(params)
      http.request(req)
    end
  end

  class RequestFacade
    attr_reader :http
    attr_reader :uri_builder
    attr_reader :session_authorization

    def initialize(http:, uri_builder:, session_authorization: nil)
      @http = http
      @uri_builder = uri_builder
      @session = session_authorization
    end

    def authorize(session_authorization)
      @session_authorization = session_authorization
    end

    def cobrand_login(login_name:, password:)
      execute(Requests::CobrandLoginRequest, login_name: login_name, password: password)
    end

    def user_login(login_name:, password:)
      execute(Requests::UserLoginRequest, login_name: login_name, password: password)
    end

    def get_accounts
      execute(Requests::GetAccountsRequest)
    end

    private

    def execute(klass, **args)
      RequestExecutor.new(self).execute(klass, args)
    end
  end

  class Connection
    class << self
      def create
        new UriBuilder.new(host: Coyodlee.host)
      end
    end

    def initialize(uri_builder)
      @uri_builder = uri_builder
    end

    def start(&block)
      Net::HTTP.start('developer.api.yodlee.com', use_ssl: true) do |http|
        yield RequestFacade.new(http: http,
                                uri_builder: @uri_builder)
      end
    end
  end
end
