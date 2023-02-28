module PayWithExtend
  class Configuration
    class EnvironmentMismatch < StandardError; end

    attr_accessor :environment, :base_url, :secure_base_url, :api_key, :account_email, :account_password, :api_version

    ENVIRONMENT_MAP = {
      "production" => "https://api.paywithextend.com",
      "development" => "https://api.paywithextend.com",
      "staging" => "https://api.paywithextend.com",
    }

    def initialize
      @environment = "production"
      @base_url = ENVIRONMENT_MAP[@environment]
      @secure_base_url = "https://v.paywithextend.com"
      @api_key = ""
      @account_email = ""
      @account_password = ""
      @api_version = ""
    end

    def environment=(environment)
      raise EnvironmentMismatch, "#{@environment} is an invalid environment value" if ENVIRONMENT_MAP[environment].nil?

      @environment = environment
      @base_url = ENVIRONMENT_MAP[@environment]
      @secure_base_url = "https://v.paywithextend.com"
    end
  end
end
