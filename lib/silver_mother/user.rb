require 'singleton'

module SilverMother
  class User
    include Singleton

    attr_reader :user

    def call(token)
      @user ||= Api.instance.get(user_path, token).to_ostruct
    end

    private

    def user_path
      'user/'
    end
  end
end
