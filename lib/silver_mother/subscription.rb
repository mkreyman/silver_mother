require 'singleton'

module SilverMother
  class Subscription
    include Singleton

    SUBS_PATH = 'subscriptions/'.freeze

    attr_reader :subscriptions_raw, :subscriptions

    def call(token)
      @token = token
      @subscriptions_raw = []
      @response = Api.instance.get(SUBS_PATH, @token)
      @subscriptions_raw << @response
      while next_page
        new_path = SUBS_PATH + next_page_number
        @response = Api.instance.get(new_path, @token)
        @subscriptions_raw << @response
      end
    end

    def subscriptions
      @subscriptions ||= @subscriptions_raw.each_with_object([]) do |sub, arr|
        arr << sub.to_ostruct.objects
      end.flatten
    end

    def clear_cache!
      @subscriptions_raw = []
      @subscriptions     = []
    end

    private

    def next_page
      @response.parsed_response['links']['next'] if @response
    end

    def next_page_number
      @response.parsed_response['links']['next'].split('/').last if next_page
    end
  end
end
