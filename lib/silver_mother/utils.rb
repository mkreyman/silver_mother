require 'singleton'
require 'logger'
require 'json'

module SilverMother
  class Utils
    include Singleton

    def logger
      @logger ||= (defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT))
    end

    def log_request(token, path, params, result)
      log_message = <<-LOG_MESSAGE
        SENSE PATH: #{base_api_url}#{path}
        SENSE PARAMS: #{add_auth_header(token, params)}
        SENSE RESPONSE: #{result.present? && result.parsed_response.inspect}
      LOG_MESSAGE

      logger.debug log_message
    end

    def add_auth_header(token, params)
      params[:headers] ||= {}
      params[:headers]['Authorization'] = "Token #{token.value}"
      params
    end

    def base_api_url
      @base_api_url ||= begin
        require 'rails'
        Rails.application.secrets.sense.fetch('api_url')
      end
    end
  end
end
