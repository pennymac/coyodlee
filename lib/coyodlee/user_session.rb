module Coyodlee
  class UserSession
    def initialize(token='')
      @token = token
    end

    def to_s
      token.empty? ? '' : "userSession=#{token}"
    end
  end
end
