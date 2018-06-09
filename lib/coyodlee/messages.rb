require 'json'

module Coyodlee
  class JsonMessage
    def initialize(message = '{}')
      @json = JSON.parse(message)
    end
  end

  class UserLoginMessage < JsonMessage
    def initialize(message = '{}')
      super(message)
    end

    def session_token
      @json.dig('user', 'session', 'userSession')
    end
  end

  class CobrandLoginMessage < JsonMessage
    def session_token
      @json.dig('session', 'cobSession')
    end
  end
end
