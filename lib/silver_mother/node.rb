require 'singleton'

module SilverMother
  class Node
    include Singleton

    NODES_PATH = 'nodes/'

    attr_reader :nodes_raw, :nodes, :uids, :node_cache, :uid_cache

    def call(token)
      @token = token
      @nodes_raw = []
      @response = Api.instance.get(NODES_PATH, @token)
      @nodes_raw << @response
      while next_page do
        new_path = NODES_PATH + next_page_number
        @response = Api.instance.get(new_path, @token)
        @nodes_raw << @response
      end
    end

    def nodes
      @nodes ||= @nodes_raw.each_with_object([]) do |node, array|
        array << node.to_ostruct.objects
      end.flatten
    end

    def uids
      @uids ||= @nodes_raw.each_with_object([]) do |node, array|
        node.to_ostruct.objects.each do |object|
          array << {
                     uid: object.uid,
                     object: object.object,
                     label: object.label,
                     type: object.type,
                     slug: object.slug
                   }
        end
      end
    end

    def node(uid)
      uid_path = NODES_PATH + uid + '/'
      @node_cache ||= {}
      @node_cache[uid] ||= Api.instance.get(uid_path, @token).to_ostruct
    end

    def feed(uid)
      feed_path = NODES_PATH + uid + '/feeds/'
      @feed_cache ||= {}
      @feed_cache[uid] ||= Api.instance.get(feed_path, @token).to_ostruct
    end

    def clear_cache!
      @nodes_raw  = []
      @nodes      = []
      @uids       = []
      @node_cache = {}
      @feed_cache = {}
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
