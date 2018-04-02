require_relative 'session_tokens'

module Coyodlee
  class SessionAuthorization
    def initialize(cobrand_session_token: NullSessionToken.new, user_session_token: NullSessionToken.new)
      @cobrand_session_token = cobrand_session_token
      @user_session_token = user_session_token
    end

    def authorize_cobrand(cobrand_session_token)
      @cobrand_session_token = cobrand_session_token
    end

    def authorize_user(user_session_token)
      @user_session_token = user_session_token
    end

    def to_s
      [@cobrand_session_token, @user_session_token]
        .select { |t| t.present? }
        .map(&:to_s)
        .join(',')
    end
  end
end
