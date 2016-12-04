require 'httparty'
require 'singleton'

module SilverMother
  class Api
    include Singleton
    include HTTParty

    def get(token, path, params = {})
      result = self.class.get(base_api_url + path, add_auth_header(token, params))
      log_request(token, path, params, result)
      result
    end

    def post(token, path, params = {})
      result = self.class.post(base_api_url + path, add_auth_header(token, params))
      log_request(token, path, params, result)
      result
    end

    def put(token, path, params = {})
      result = self.class.put(base_api_url + path, add_auth_header(token, params))
      log_request(token, path, params, result)
      result
    end

    def delete(token, path, params = {})
      result = self.class.delete(base_api_url + path, add_auth_header(token, params))
      log_request(token, path, params, result)
      result
    end

    private

    def base_api_url
      Utils.instance.base_api_url
    end

    def log_request(token, path, params, result)
      Utils.instance.log_request(token, path, params, result)
    end

    def add_auth_header(token, params)
      Utils.instance.add_auth_header(token, params)
    end
  end
end

HTTParty::Response.class_eval do
  def to_ostruct
    JSON.parse(self.to_json, object_class: OpenStruct)
  end
end

