require 'json'
require 'coyodlee/utils'

module Coyodlee
  module Sessions
    class CobrandSession
      include Utils

      # Holds the cobrand session token
      #
      # @return [String] the cobrand session token
      attr_reader :token

      # Creates a new cobrand session
      def initialize
        @token = ''
      end

      # Initiates a cobrand session
      #
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def login(login_name:, password:)
        HttpWrapper.post(
          url: build_url("/cobrand/login"),
          body: {
            cobrand: {
              cobrandLogin: login_name,
              cobrandPassword: password,
              locale: 'en_US'
            }
          }.to_json,
          headers: { content_type: :json, accept: :json }
        ).tap { |response|
          @token = JSON.parse(response.body)['session']['cobSession']
        }
      end

      # Returns a string containing the cobrand session token which can be used as the value of the Authorization HTTP header
      def auth_header
        @token.empty? ? '' : "cobSession=#{@token}"
      end

      # Terminates the cobrand session
      #
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def logout
        HttpWrapper.post(
          url: build_url("/cobrand/logout")
        )
      end
    end
  end
end
