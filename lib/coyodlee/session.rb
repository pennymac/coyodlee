require_relative 'session_authorization'
require_relative 'session_tokens'
require_relative 'messages'
require 'json'

module Coyodlee
  class Session
    attr_writer :session_token_klass

    class << self
      def create(request_facade)
        new(request_facade).tap do |session|
          session.session_token_klass = SessionToken
        end
      end
    end

    def initialize(request_facade)
      @api = request_facade
    end

    def login_cobrand(login_name:, password:)
      @api.login_cobrand(login_name: login_name,
                         password: password).tap do |res|
        msg = CobrandLoginMessage.new(res.body)
        @api.authorize_cobrand(msg.session_token)
      end
    end

    def login_user(login_name:, password:)
      @api.login_user(login_name: login_name,
                      password: password).tap do |res|
        msg = UserLoginMessage.new(res.body)
        @api.authorize_user(msg.session_token)
      end
    end
  end
end
