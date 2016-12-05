require 'singleton'
require 'httparty'

module SilverMother
  class UserToken
    include Singleton
    include HTTParty

    def call(user)
      result = self.class.post(user_token_url, params(user))
      @token = result.fetch('token')
      Utils.instance.log_request(@token, path, params(user), result)
      @token
    end

    private

    def params(user)
      {
        headers: { 'Content-Type' => 'application/json' },
        body: {
          username: user.username,
          password: user.password,
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
