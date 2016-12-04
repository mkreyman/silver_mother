require 'singleton'

module SilverMother
  class User
    include Singleton

    def call(token)
      @user_raw = Api.instance.get(token, path)
    end

    def user
      @user ||= @user_raw.to_ostruct
    end

    private

    def path
      'user/'
    end
  end
end
