require 'singleton'

module SilverMother
  class Event
    include Singleton

    NUMBER_OF_EVENTS = 10
    TTL = 300

    def call(token)
      @token = token
      @feeds_api = SilverMother::Feed.instance
      @feeds_api.call(@token)
      @nodes_api = SilverMother::Node.instance
      @nodes_api.call(@token)
    end

    def feeds
      @feeds ||= @feeds_api.feeds
    end

    def feed_uids
      @feed_uids ||= @feeds_api.uids
    end

    def nodes
      @nodes ||= @nodes_api.nodes
    end

    def node_uids
      @node_uids ||= @nodes_api.uids
    end

    def events(options={})
      uid = options[:uid]
      type = options[:type]
      limit = options[:limit] || NUMBER_OF_EVENTS
      secs = options[:secs] || TTL
      @event_cache ||= {}
      @ttls ||= {}
      clear_cache(uid) if expired?(@ttls[uid])
      @ttls[uid] ||= ttl(secs)
      @event_cache[uid] ||= Api.instance.get(@token, path(uid, limit, type)).to_ostruct.objects
    end

    def clear_cache!
      @event_cache = {}
      @ttls = {}
    end

    private

    def path(uid, limit, type=nil)
      if type
        "nodes/#{uid}/feeds/#{type}/events/?limit=#{limit}"
      else
        "feeds/#{uid}/events/?limit=#{limit}"
      end
    end

    def ttl(secs)
      Time.now.to_i + secs.to_i
    end

    def expired?(ttl)
      Time.now.to_i > ttl.to_i
    end

    def clear_cache(uid)
      @event_cache.delete(uid)
      @ttls.delete(uid)
    end
  end
end
