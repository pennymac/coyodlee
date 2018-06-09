require_relative 'session_tokens'

module Coyodlee
  # SessionAuthorization stores cobrand and user session tokens. Its purpose is to
  # make it easy to recreate the Authentication header that must be included in
  # authenticated requests to the Yodlee API
  class SessionAuthorization
    # @return [SessionToken] the cobrand session token
    attr_accessor :cobrand_session_token
    # @return [SessionToken] the user session token
    attr_accessor :user_session_token

    class << self
      def create(authorization=NullSessionAuthorization.new)
        new(cobrand_session_token: authorization.cobrand_session_token,
            user_session_token: authorization.user_session_token)
      end
    end

    def initialize(cobrand_session_token: NullSessionToken.new, user_session_token: NullSessionToken.new)
      @cobrand_session_token = cobrand_session_token
      @user_session_token = user_session_token
    end

    # @return [String] Returns the cobrand (and user) session as a string to be used in the Authentication header
    def to_s
      ['cobSession', 'userSession']
        .zip([@cobrand_session_token, @user_session_token])
        .select { |_, token| token.present? }
        .map { |k, token| [k, token.to_s] }
        .map { |arr| arr.join('=') }
        .join(',')
    end
  end

  class NullSessionAuthorization
    def cobrand_session_token
      @cobrand_session_token ||= NullSessionToken.new
    end

    def user_session_token
      @user_session_token ||= NullSessionToken.new
    end
  end
end
