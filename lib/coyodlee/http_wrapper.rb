require "rest-client"

module Coyodlee
  module HttpWrapper
    class << self
      def get(url:, params: {}, headers: {})
        if params.empty?
          RestClient.get(url, headers)
        else
          RestClient.get(url, { params: params }.merge(headers))
        end
      end

      def post(url:, body:, headers: {})
        begin
          RestClient.post(url, body, headers)
        rescue RestClient::ExceptionWithResponse => err
          err.response
        end
      end

      def put(url:, body:, headers: {})
        RestClient.put(url, body, headers)
      end

      def delete(url:, headers: {})
        RestClient.delete(url, headers)
      end
    end
  end
end
