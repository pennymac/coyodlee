module Coyodlee
  class Session
    attr_writer :cobrand_session
    attr_writer :user_session

    def initialize(cobrand_session: nil, user_session: nil)
      @cobrand_session = cobrand_session
      @user_session = user_session
    end

    def to_s
      [@cobrand_session.to_s, @user_session.to_s]
        .reject { |s| s.empty? }
        .join(',')
    end
  end
end
