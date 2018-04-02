module Coyodlee
  class NullSessionToken
    def present?
      false
    end

    def to_s
      ''
    end
  end

  class UserSessionToken
    def initialize(token='')
      @token = token
    end

    def present?
      !@token.empty?
    end

    def to_s
      @token.empty? ? '' : "userSession=#{@token}"
    end
  end

  class CobrandSessionToken
    def initialize(token='')
      @token = token
    end

    def present?
      !@token.empty?
    end

    def to_s
      @token.empty? ? '' : "cobSession=#{@token}"
    end
  end
end
