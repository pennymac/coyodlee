module Coyodlee
  module Utils
    # Converts a string to camel-case with the first letter uncapitalized
    # @param str [String] The string to modify
    # @return [String] The string as camel-cased with the first letter uncapitalized
    def uncapitalized_camelize(str)
      str
        .split('_')
        .map { |w| w.capitalize }
        .join
        .tap { |w| w[0] = w[0].downcase }
    end

    def sub_underscore(str)
      str.sub(/^_/, '')
    end

    def sub_double_underscore(str)
      str.gsub(/__/, '.')
    end

    def build_url(path)
      ::Coyodlee.base_url.to_s + path
    end
  end
end
