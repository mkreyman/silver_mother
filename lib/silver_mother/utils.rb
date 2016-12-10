require 'singleton'
require 'logger'
require 'json'

module SilverMother
  class Utils
    include Singleton

    def logger
      @logger ||= (defined?(Rails) ? Rails.logger : ::Logger.new(STDOUT))
    end

    def log_request(path, params, result)
      log_message = <<-LOG_MESSAGE
        \n
        SENSE PATH: #{Api::DEFAULT_API_URL}#{path}
        SENSE PARAMS: #{params.inspect}
        SENSE RESPONSE: #{result.success? && result.parsed_response.inspect}
      LOG_MESSAGE

      logger.debug log_message
    end
  end
end
