module Coyodlee
  class UriBuilder
    def initialize(host:, cobrand: 'restserver', version: 'v1')
      @cobrand = cobrand
      @version = version
      @host = host
      @path_prefix = 'ysl'
    end

    def build(resource_path, query: nil, use_ssl: true)
      uri_builder = use_ssl ? URI::HTTPS : URI::HTTP
      revised_resource_path = resource_path.start_with?('/') ? resource_path.slice(1..-1) : resource_path
      path = "/#{@path_prefix}/#{@cobrand}/#{@version}/#{revised_resource_path}"
      uri_builder.build(host: @host, path: path, query: query)
    end
  end
end
