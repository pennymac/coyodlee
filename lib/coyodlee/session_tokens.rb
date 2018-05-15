module Coyodlee
  class NullSessionToken
    # @return [Boolean] false
    def present?
      false
    end

    # @return [String] the empty string
    def to_s
      ''
    end
  end

  class SessionToken
    def initialize(token='')
      @token = token
    end

    # @return [Boolean] Returns true if the token is not empty; false otherwise
    def present?
      !@token.empty?
    end

    # @return [String] Returns the string value of the token
    def to_s
      @token
    end
  end
end
