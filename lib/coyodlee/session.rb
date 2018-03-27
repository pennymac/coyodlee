module Coyodlee
  class Session
    attr_writer :cobrand_session
    attr_writer :user_session

    def initialize(cobrand_session: nil, user_session: nil)
      @cobrand_token = cobrand_token
      @user_token = user_token
    end

    def auth_header
      [@cob_session.to_s, @user_session.to_s]
        .reject { |s| s.empty? }
        .join(',')
    end
  end
end
