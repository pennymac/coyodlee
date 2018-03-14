require 'json'

module Coyodlee
  module Sessions
    class UserSession
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
        res = HttpWrapper.post(
          url: "#{::Coyodlee.base_url}/user/login",
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
          Rails.logger.info "Login#{response.code}:::::#{JSON.parse(response.body)['user']['session']['userSession']}" if response.code == 200
          @token = JSON.parse(response.body)['user']['session']['userSession'] if response.code == 200
        }
      end

      # Registers a user. If the register is successful, the {#token} will be
      # set
      #
      # @param login_name [String] the login name of the user
      # @param password [String] the password of the user
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def register(login_name:, password:, email:)
        HttpWrapper.post(
          url: "#{::Coyodlee.base_url}/user/register",
          body: {
            user: {
              loginName: login_name,
              password: password,
              email: email
            }
          }.to_json,
          headers: {
            content_type: :json,
            accept: :json,
            authorization: @cobrand_session.auth_header
          }
        ).tap do |response|
          Rails.logger.info "#{response.code}:::::#{JSON.parse(response.body)['user']['session']['userSession']}" if response.code == 200
          @token = JSON.parse(response.body)['user']['session']['userSession'] if response.code == 200
        end
      end

      # Attempt to login a user and register if the login attempt fails.
      # If the either attempt is successful, the {#token} will be
      # set
      #
      # @param login_name [String] the login name of the user
      # @param password [String] the password of the user
      # @param email [String] the email of the user
      # @return the underlying response object for the HTTP client you've selected, RestClient by default
      def login_or_register(login_name:, password:, email:)
        resp = login(login_name: login_name, password: password)
        resp.code == 200 ? resp : register(login_name: login_name, password: password, email: email)
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
          url: "#{::Coyodlee.base_url}/user/logout"
        )
      end
    end
  end
end
