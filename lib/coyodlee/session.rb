require_relative 'cobrand_session_token'
require_relative 'user_session_token'
require_relative 'session_authorization'

module Coyodlee
  class Session
    attr_reader :authorization
    attr_writer :cobrand_session_token_klass
    attr_writer :user_session_token_klass

    class << self
      def create(request_facade)
        new(request_facade: request_facade,
            session_authorization: SessionAuthorization.new).tap do |session|
          session.cobrand_session_token_klass = CobrandSessionToken
          session.user_session_token_klass = UserSessionToken
        end
      end
    end

    def initialize(request_facade:, session_authorization:)
      @api = request_facade
      @authorization = session_authorization
    end

    def cobrand_login(login_name:, password:)
      @api.cobrand_login(login_name: login_name,
                         password: password).tap do |res|
        body = JSON.parse(res.body)
        token = body.dig('session', 'cobSession')
        @authorization.authorize_cobrand(@cobrand_session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end

    def user_login(login_name:, password:)
      @api.user_login(login_name: login_name,
                      password: password).tap do |res|
        body = JSON.parse(res.body)
        token = body.dig('user', 'session', 'userSession')
        @authorization.authorize_user(@user_session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end
  end
end
