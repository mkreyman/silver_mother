require 'singleton'

module SilverMother
  class Node
    include Singleton

    def call(token)
      @token = token
      @nodes_raw = []
      @response = Api.instance.get(@token, path)
      @nodes_raw << @response
      while next_page do
        new_path = path + next_page_number
        @response = Api.instance.get(@token, new_path)
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
          array << object.uid
        end
      end
    end

    def node(uid)
      uid_path = path + uid + '/'
      Api.instance.get(@token, uid_path).to_ostruct
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

# Examples
#
# Fetch token first:
# token = SilverMother::Token.new('your_username', 'your_password')
#
# nodes_api = SilverMother::Node.instance
# nodes_api.call(token)
# nodes = nodes_api.nodes
# uids = nodes_api.uids
#
# nodes is an array of node objects that you could iterate over. i.e.
# node = nodes.first
#
# Attributes/methods available for the node now:
# :uid, :label, :url, :resource, :token, :object, :geometry, :createdAt,
# :updatedAt, :paused, :subscribes, :publishes
#
# Some attributes are objects or arrays of objects that you could further explore, i.e.
# node.resource.type
# node.publishes[0].url
#
# There's another way to get a node, assuming you've run nodes_api.uids
# to get a list of uids:
# node = nodes_api.node(uid)


