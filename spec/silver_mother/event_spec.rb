require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Event do
    events_api = SilverMother::Event.instance
    events_api.token = 'stubbed-application-token'

    it 'returns events for a node uid' do
      event_params = {
                       uid:   'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A',
                       type:  'notification',
                       limit: 1
                     }

      event_path = "nodes/#{event_params[:uid]}/feeds/#{event_params[:type]}/events/?limit=#{event_params[:limit]}"

      stub_request(:get, Api::DEFAULT_API_URL + event_path)
        .with(:headers => {'Authorization' => "Bearer #{events_api.token}"})
        .to_return(body: fixture('dummy_node_event.json'))

      expected_events = JSON.parse(fixture('dummy_node_event.json'), object_class: OpenStruct).objects
      expect(events_api.events(event_params)).to eq expected_events
    end

    it 'returns events for a feed uid' do
      event_params = {
                       uid:   'GS5vq3D3MvqUZmBqRQoQY9Av4KRgHPvs',
                       limit: 1
                     }

      event_path = "feeds/#{event_params[:uid]}/events/?limit=#{event_params[:limit]}"

      stub_request(:get, Api::DEFAULT_API_URL + event_path)
        .with(:headers => {'Authorization' => "Bearer #{events_api.token}"})
        .to_return(body: fixture('dummy_feed_event.json'))

      expected_events = JSON.parse(fixture('dummy_feed_event.json'), object_class: OpenStruct).objects
      expect(events_api.events(event_params)).to eq expected_events
    end
  end
end
