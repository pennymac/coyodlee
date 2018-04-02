require_relative 'session_authorization'
require_relative 'session_tokens'
require 'json'

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

    def login_cobrand(login_name:, password:)
      @api.login_cobrand(login_name: login_name,
                         password: password).tap do |res|
        body = JSON.parse(res.body)
        token = body.dig('session', 'cobSession')
        @authorization.authorize_cobrand(@cobrand_session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end

    def login_user(login_name:, password:)
      @api.login_user(login_name: login_name,
                      password: password).tap do |res|
        body = JSON.parse(res.body)
        token = body.dig('user', 'session', 'userSession')
        @authorization.authorize_user(@user_session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end
  end
end
