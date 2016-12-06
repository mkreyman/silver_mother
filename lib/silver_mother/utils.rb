require 'singleton'
require 'logger'
require 'json'

module SilverMother
  class Utils
    include Singleton

    def logger
      @logger ||= (defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT))
    end

    def log_request(path, params, token, result)
      log_message = <<-LOG_MESSAGE
        \n
        SENSE PATH: #{Api::DEFAULT_API_URL}#{path}
        SENSE PARAMS: #{add_auth_header(params, token)}
        SENSE RESPONSE: #{result.success? && result.parsed_response.inspect}
      LOG_MESSAGE

      logger.debug log_message
    end

    def add_auth_header(params, token=false)
      params[:headers] ||= {}
      params[:headers]['Authorization'] = "Token #{token}" if token
      params
    end
  end
end
