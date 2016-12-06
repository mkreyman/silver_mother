require 'singleton'

module SilverMother
  class Node
    include Singleton

    def call(token)
      @token = token
      @nodes_raw = []
      @response = Api.instance.get(path, @token)
      @nodes_raw << @response
      while next_page do
        new_path = path + next_page_number
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
      uid_path = path + uid + '/'
      @node_cache ||= {}
      @node_cache[uid] ||= Api.instance.get(uid_path, @token).to_ostruct
    end

    def feed(uid)
      feed_path = path + uid + '/feeds/'
      @feed_cache ||= {}
      @feed_cache[uid] ||= Api.instance.get(feed_path, @token).to_ostruct
    end

    private

    def path
      'nodes/'
    end

    def next_page
      @response.parsed_response['links']['next'] if @response
    end

    def next_page_number
      @response.parsed_response['links']['next'].split('/').last if next_page
    end
  end
end
