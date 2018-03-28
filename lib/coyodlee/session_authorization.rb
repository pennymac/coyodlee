module Coyodlee
  class SessionAuthorization
    attr_writer :cobrand_session_token
    attr_writer :user_session_token

    def initialize(cobrand_session_token: nil, user_session_token: nil)
      @cobrand_session_token = cobrand_session_token
      @user_session_token = user_session_token
    end

    def to_s
      [@cobrand_session_token.to_s, @user_session_token.to_s]
        .reject { |s| s.empty? }
        .join(',')
    end
  end
end
