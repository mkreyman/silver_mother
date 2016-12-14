require 'singleton'

module SilverMother
  class Event
    include Singleton

    attr_accessor :token
    attr_reader :feeds,
                :feed_uids,
                :nodes,
                :node_uids,
                :event_cache,
                :ttls

    def call(token)
      @token     = token
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

    def events(uid, type = nil)
      @event_cache ||= {}
      @ttls ||= {}
      clear_cache(uid) if expired?(@ttls[uid])
      @ttls[uid] ||= ttl(TTL)
      @event_cache[uid] ||= Api.instance
                               .get(path(uid, type), @token)
                               .to_ostruct
                               .objects
    end

    def clear_cache!
      @event_cache = {}
      @ttls        = {}
    end

    private

    def path(uid, type = nil)
      if type
        "nodes/#{uid}/feeds/#{type}/events/?limit=#{NUM_OF_RESULTS}"
      else
        "feeds/#{uid}/events/?limit=#{NUM_OF_RESULTS}"
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
