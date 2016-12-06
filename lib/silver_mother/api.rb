require 'httparty'
require 'singleton'

module SilverMother
  class Api
    include Singleton
    include HTTParty

    DEFAULT_API_URL = 'https://apis.sen.se/v2/'

    def get(path, params = {}, token)
      result = self.class.get(DEFAULT_API_URL + path, add_auth_header(params, token))
      log_request(path, params, token, result)
      result
    end

    def post(path, params = {}, token=nil)
      result = self.class.post(DEFAULT_API_URL + path, add_auth_header(params, token))
      log_request(path, params, token, result)
      result
    end

    def put(path, params = {}, token)
      result = self.class.put(DEFAULT_API_URL + path, add_auth_header(params, token))
      log_request(path, params, token, result)
      result
    end

    def delete(path, params = {}, token)
      result = self.class.delete(DEFAULT_API_URL + path, add_auth_header(params, token))
      log_request(path, params, token, result)
      result
    end

    private

    def log_request(path, params, token, result)
      Utils.instance.log_request(path, params, token, result)
    end

    def add_auth_header(params, token)
      Utils.instance.add_auth_header(params, token)
    end
  end
end

HTTParty::Response.class_eval do
  def to_ostruct
    JSON.parse(self.to_json, object_class: OpenStruct)
  end
end

