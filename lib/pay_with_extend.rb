require_relative "pay_with_extend/version"
require "pay_with_extend/configuration"
require "pay_with_extend/client"

module PayWithExtend
  class Error < StandardError; end
  
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
