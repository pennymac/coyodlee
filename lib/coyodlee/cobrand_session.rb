module Coyodlee
  class CobrandSession
    def initialize(token='')
      @token = token
    end

    def to_s
      @token.empty? ? '' : "cobSession=#{@token}"
    end
  end
end
