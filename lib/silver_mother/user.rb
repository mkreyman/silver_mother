module SilverMother
  class User
    attr_reader :username, :password, :token, :data

    def initialize(username, password)
      @username = username
      @password = password
    end

    def token
      @token ||= Api.instance.post(user_token_path, nil, params).to_ostruct.token
    end

    def data
      @data ||= Api.instance.get(user_path, token).to_ostruct
    end

    private

    def params
      {
        headers: { 'Content-Type' => 'application/json' },
        body: {
          username: @username,
          password: @password,
        }.to_json
      }
    end

    def user_token_path
      'user/api_key/'
    end

    def user_path
      'user/'
    end
  end
end
