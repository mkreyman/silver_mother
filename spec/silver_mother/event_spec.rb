require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Event do
    events_api = SilverMother::Event.instance
    events_api.token = 'stubbed-application-token'

    it 'returns events for a node uid' do
      uid = 'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A'
      type = 'notification'

      event_path = "nodes/#{uid}/feeds/#{type}/events/?limit=#{NUM_OF_RESULTS}"

      stub_request(:get, SENSE_API_URL + event_path)
        .with(headers: { 'Authorization' => "Bearer #{events_api.token}" })
        .to_return(body: fixture('dummy_node_event.json'))

      expected_events = JSON.parse(fixture('dummy_node_event.json'),
                                   object_class: OpenStruct).objects

      expect(events_api.events(uid, type)).to eq expected_events
    end

    it 'returns events for a feed uid' do
      uid = 'GS5vq3D3MvqUZmBqRQoQY9Av4KRgHPvs'
      event_path = "feeds/#{uid}/events/?limit=#{NUM_OF_RESULTS}"

      stub_request(:get, SENSE_API_URL + event_path)
        .with(headers: { 'Authorization' => "Bearer #{events_api.token}" })
        .to_return(body: fixture('dummy_feed_event.json'))

      expected_events = JSON.parse(fixture('dummy_feed_event.json'),
                                   object_class: OpenStruct).objects

      expect(events_api.events(uid)).to eq expected_events
    end
  end
end
