module Coyodlee
  class UriBuilder
    def initialize(host:, cobrand: 'restserver', version: 'v1')
      @cobrand = cobrand
      @version = version
      @host = host
    end

    def build(relative_path, query: nil, use_ssl: true)
      uri_builder = use_ssl ? URI::HTTPS : URI::HTTP
      path_fragment = relative_path.start_with?('/') ? relative_path.slice(1..-1) : relative_path
      path = "/#{@cobrand}/#{@version}/#{path_fragment}"
      uri_builder.build(host: @host, path: path, query: query)
    end
  end
end
