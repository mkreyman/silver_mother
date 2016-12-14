require 'httparty'
require 'singleton'

module SilverMother
  class Api
    include Singleton
    include HTTParty

    # Uncomment for debugging
    # debug_output

    DEFAULT_API_URL = 'https://apis.sen.se/v2/'

    def get(path, token, params = {})
      result = HTTParty.get(DEFAULT_API_URL + path, add_auth_header(token, params))
      log_request(path, params, result)
      result
    end

    def post(path, token, params = {})
      result = HTTParty.post(DEFAULT_API_URL + path, add_auth_header(token, params))
      log_request(path, params, result)
      result
    end

    def put(path, token, params = {})
      result = HTTParty.put(DEFAULT_API_URL + path, add_auth_header(token, params))
      log_request(path, params, result)
      result
    end

    def delete(path, token, params = {})
      result = HTTParty.delete(DEFAULT_API_URL + path, add_auth_header(token, params))
      log_request(path, params, result)
      result
    end

    private

    def add_auth_header(token=false, params)
      params[:headers] ||= {}
      params[:headers]['Authorization'] = "Bearer #{token}" if token
      params
    end

    def log_request(path, params, result)
      Utils.instance.log_request(path, params, result)
    end
  end
end

HTTParty::Response.class_eval do
  def to_ostruct
    JSON.parse(self.to_json, object_class: OpenStruct)
  rescue JSON::ParserError
    JSON.parse(self, object_class: OpenStruct)
  end
end

