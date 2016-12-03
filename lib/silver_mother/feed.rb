require 'singleton'

module SilverMother
  class Feed
    include Singleton

    def call(token)
      @token = token
      @feeds_raw = []
      @response = Api.instance.get(@token, path)
      @feeds_raw << @response
      while next_page do
        new_path = path + next_page_number
        @response = Api.instance.get(@token, new_path)
        @feeds_raw << @response
      end
    end

    def feeds
      @feeds ||= @feeds_raw.each_with_object([]) do |feed, array|
        array << feed.to_ostruct.objects
      end.flatten
    end

    def uids
      @uids ||= @feeds_raw.each_with_object([]) do |feed, array|
        feed.to_ostruct.objects.each do |object|
          array << { uid: object.uid, type: object.type }
        end
      end
    end

    def feed(uid)
      feed_path = path + uid + '/'
      @feed_cache ||= {}
      @feed_cache[uid] ||= Api.instance.get(@token, feed_path).to_ostruct
    end

    private

    def path
      'feeds/'
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
# feeds_api = SilverMother::Feed.instance
# feeds_api.call(token)
# feeds = feeds_api.feeds
# uids = feeds_api.uids
#
# To get a feed (or feeds) for a particular uid:
# feed = feeds_api.feed(uid)
#
# Attributes/methods available for the feed now:
# uid, eventsModel, eventsUrl, label, node, object, type, url, used.
#
# Some attributes are objects or arrays of objects that you could further explore, i.e.
# feed.eventsModel.geometry
