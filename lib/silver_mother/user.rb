require 'singleton'

module SilverMother
  class User
    include Singleton

    def call(token)
      @user = Api.instance.get(token, path)
    end

    def user
      @user.to_ostruct
    end

    private

    def path
      'user/'
    end
  end
end

# Examples
#
# Fetch token first:
# token = SilverMother::Token.new('your_username', 'your_password')
#
# user_api = SilverMother::User.instance
# user_api.call(token)
# user = user_api.user
#
# Attributes/methods available for the user now:
# :uid, :email, :language, :object, :timezone, :country, :username,
# :subscriptions, :applications, :createdAt, :updatedAt, :is_developer,
# :firstName, :lastName, :devices, :persons
#
# Some attributes are objects or arrays of objects that you could further explore, i.e.
# user.subscriptions[0].uid
# user.applications.first.label
# user.devices.last.url
# user.persons[1].firstName
