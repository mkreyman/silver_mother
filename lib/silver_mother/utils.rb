require 'singleton'
require 'logger'
require 'json'

module SilverMother
  class Utils
    include Singleton

    DEFAULT_API_URL = 'https://apis.sen.se/v2/'

    def logger
      @logger ||= (defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT))
    end

    def log_request(token, path, params, result)
      log_message = <<-LOG_MESSAGE
        \n
        SENSE PATH: #{base_api_url}#{path}
        SENSE PARAMS: #{add_auth_header(token, params)}
        SENSE RESPONSE: #{result.success? && result.parsed_response.inspect}
      LOG_MESSAGE

      logger.debug log_message
    end

    def add_auth_header(token, params)
      params[:headers] ||= {}
      params[:headers]['Authorization'] = "Token #{token}"
      params
    end

    def base_api_url
      DEFAULT_API_URL
    end
  end
end
