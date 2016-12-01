require 'singleton'

module SilverMother
  class Subscription
    include Singleton

    def call(token)
      @token = token
      @subscriptions_raw = []
      @response = Api.instance.get(@token, path)
      @subscriptions_raw << @response
      while next_page do
        new_path = path + next_page_number
        @response = Api.instance.get(@token, new_path)
        @subscriptions_raw << @response
      end
    end

    def subscriptions
      @subscriptions ||= @subscriptions_raw.each_with_object([]) do |subscription, array|
        array << subscription.to_ostruct.objects
      end.flatten
    end

    private

    def path
      'subscriptions/'
    end

    def next_page
      @response.parsed_response['links']['next'] if @response
    end

    def next_page_number
      @response.parsed_response['links']['next'].split('/').last if next_page
    end
  end
end

# Examples
#
# Fetch token first:
# token = SilverMother::Token.new('your_username', 'your_password')
#
# subscriptions_api = SilverMother::Subscription.instance
# subscriptions_api.call(token)
# subscriptions = subscriptions_api.subscriptions
# subscription = subscriptions.first
#
# Attributes/methods available for the subscription now:
# uid, createdAt, updatedAt, gatewayUrl, geometry, label, object, paused,
# publishes, resource, subscribes, url.
#
# Some attributes are objects or arrays of objects that you could further explore, i.e.
# subscription.subscribes[0].type

