require_relative 'coyodlee/version'
require 'yajl'

# The global Yodlee configuration object
module Coyodlee

  class << self
    # The base url Yodlee provides for your cobrand
    # @return [String] The base url Yodlee provides for your cobrand
    attr_accessor :base_url
    # The name of the Yodlee API host
    # @return [String] The name of the Yodlee API host
    attr_accessor :host
    # The cobrand name
    # @return [String] The cobrand name
    attr_accessor :cobrand_name
    # The login of your cobrand
    # @return [String] The login of your cobrand
    attr_accessor :cobrand_login
    # The password of your cobrand
    # @return [String] The password of your cobrand
    attr_accessor :cobrand_password

    # The method to configure Yodlee parameters. Use this to set the global parameters such as {Yodlee.base_url}, {Yodlee.cobrand_login}, and {Yodlee.cobrand_password}
    # @yieldparam config [Yodlee] The Yodlee object
    def setup &block
      yield self
    end
  end
end
