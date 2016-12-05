module SilverMother
  class User

    attr_reader :username, :password, :token, :object

    def initialize(username, password)
      @username = username
      @password = password
    end

    def token
      @token ||= UserToken.instance.call(self)
    end

    def object
      @object ||= Api.instance.get(token, path).to_ostruct
    end

    private

    def path
      'user/'
    end
  end
end
