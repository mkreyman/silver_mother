require 'singleton'

module SilverMother
  class User
    include Singleton

    USER_PATH = 'user/'

    attr_reader :user

    def call(token)
      @user ||= Api.instance.get(USER_PATH, token).to_ostruct
    end
  end
end
