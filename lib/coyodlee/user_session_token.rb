module Coyodlee
  class UserSessionToken
    def initialize(token='')
      @token = token
    end

    def to_s
      @token.empty? ? '' : "userSession=#{@token}"
    end
  end
end
