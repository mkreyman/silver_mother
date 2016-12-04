require 'httparty'

module SilverMother
  class Token
    include HTTParty

    attr_reader :username, :password, :value

    def initialize(username, password)
      @username = username
      @password = password
      fetch_token
    end

    private

    def fetch_token
      result = self.class.post(user_token_url, params)
      @value = result.fetch('token')
      Utils.instance.log_request(self, path, params, result)
    end

    def params
      {
        headers: { 'Content-Type' => 'application/json' },
        body: {
          username: @username,
          password: @password,
        }.to_json
      }
    end

    def path
      'user/api_key/'
    end

    def user_token_url
      Utils.instance.base_api_url + path
    end
  end
end
