require_relative 'session_authorization'
require_relative 'session_tokens'
require 'json'

module Coyodlee
  class Session
    attr_reader :authorization
    attr_writer :session_token_klass

    class << self
      def create(request_facade)
        new(request_facade: request_facade,
            session_authorization: SessionAuthorization.new).tap do |session|
          session.session_token_klass = SessionToken
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
        @authorization.authorize_cobrand(@session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end

    def login_user(login_name:, password:)
      @api.login_user(login_name: login_name,
                      password: password).tap do |res|
        body = JSON.parse(res.body)
        token = body.dig('user', 'session', 'userSession')
        @authorization.authorize_user(@session_token_klass.new(token))
        @api.authorize(@authorization)
      end
    end
  end
end
