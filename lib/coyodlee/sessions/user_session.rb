require 'json'
require 'coyodlee/utils'

module Coyodlee
  module Sessions
    class UserSession
      include Utils

      # Holds the user session token
      #
      # @return [String] the user session token
      attr_reader :token

      # Creates a new user session
      #
      # @param cobrand_session [CobrandSession] the cobrand session
      def initialize(cobrand_session:)
        @token = ''
        @cobrand_session = cobrand_session
      end

      # Initiates a user session. If the login is successful, the {#token} will be
      # set
      #
      # @param login_name [String] the login name of the user
      # @param password [String] the password of the user
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def login(login_name:, password:)
        HttpWrapper.post(
          url: build_url("/user/login"),
          body: {
            user: {
              loginName: login_name,
              password: password,
              locale: 'en_US'
            }
          }.to_json,
          headers: {
            content_type: :json,
            accept: :json,
            authorization: @cobrand_session.auth_header
          }
        ).tap { |response|
          @token = JSON.parse(response.body)['user']['session']['userSession']
        }
      end

      # Returns a string containing the cobrand session token and the user session token which can be used as the value of the Authorization HTTP header
      def auth_header
        @token.empty? ? '' : "cobSession=#{@cobrand_session.token},userSession=#{@token}"
      end

      # Terminates the user session
      #
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def logout
        HttpWrapper.post(
          url: build_url("/user/logout")
        )
      end
    end
  end
end
