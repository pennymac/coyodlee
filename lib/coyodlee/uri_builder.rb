module Coyodlee
  class UriBuilder
    attr_reader :host
    attr_reader :cobrand

    def initialize(host:, cobrand: 'restserver', version: 'v1')
      @cobrand = cobrand || 'restserver'
      @version = version
      @host = host
      @path_prefix = 'ysl'
    end

    def build(resource_path, query: nil, use_ssl: true)
      uri_builder = use_ssl ? URI::HTTPS : URI::HTTP
      revised_resource_path = if resource_path.start_with?('/')
                                resource_path.slice(1..-1)
                              else
                                resource_path
                              end
      path = [@path_prefix, @cobrand, @version, revised_resource_path]
               .compact
               .join('/')
               .prepend('/')
      uri_builder.build(host: @host, path: path, query: query)
    end
  end
end
