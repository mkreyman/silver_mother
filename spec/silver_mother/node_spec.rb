require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Node do
    token = 'stubbed-application-token'
    nodes_api = SilverMother::Node.instance

    before :all do
      stub_request(:get, Api::DEFAULT_API_URL + 'nodes/')
        .with(:headers => {'Authorization' => "Bearer #{token}"})
        .to_return(:body => fixture('dummy_nodes.json'))

      nodes_api.call(token)
    end

    context 'with all data' do
      it 'pulls raw nodes with #call' do
        expected_raw_node_data = fixture('dummy_nodes.json')
        expect(nodes_api.nodes_raw[0].parsed_response).to eq expected_raw_node_data
      end

      it 'extracts node data with #nodes' do
        expected_nodes = JSON.parse(fixture('dummy_nodes.json'), object_class: OpenStruct).objects
        expect(nodes_api.nodes).to eq expected_nodes
      end

      it 'extracts uid data with #uids' do
        expected_uid = 'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A'
        expect(nodes_api.uids[0][:uid]).to eq expected_uid
      end
    end

    context 'for a specific uid' do
      it 'provides node data' do
        uid = '6gqyjjGi0WMYa12pzT7cPgQ3H6M9gKYr'
        expected_node_data = JSON.parse(fixture('dummy_node.json'), object_class: OpenStruct)

        stub_request(:get, Api::DEFAULT_API_URL + 'nodes/' + uid + '/')
          .with(:headers => {'Authorization' => "Bearer #{token}"})
          .to_return(:body => fixture('dummy_node.json'))

        expect(nodes_api.node(uid)).to eq expected_node_data
      end

      it 'provides feed data' do
        uid = 'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A'
        expected_feed_data = JSON.parse(fixture('dummy_feed.json'), object_class: OpenStruct)

        stub_request(:get, Api::DEFAULT_API_URL + 'nodes/' + uid + '/feeds/')
          .with(:headers => {'Authorization' => "Bearer #{token}"})
          .to_return(:body => fixture('dummy_feed.json'))

        expect(nodes_api.feed(uid)).to eq expected_feed_data
      end
    end
  end
end
