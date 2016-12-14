require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Feed do
    token = 'stubbed-application-token'
    feeds_api = SilverMother::Feed.instance

    before :all do
      stub_request(:get, Api::DEFAULT_API_URL + 'feeds/')
        .with(:headers => {'Authorization' => "Bearer #{token}"})
        .to_return(:body => fixture('dummy_feeds.json'))

      feeds_api.call(token)
    end

    context 'with all data' do
      it 'pulls raw feeds with #call' do
        expected_raw_feed_data = fixture('dummy_feeds.json')
        expect(feeds_api.feeds_raw[0].parsed_response).to eq expected_raw_feed_data
      end

      it 'extracts feed data with #feeds' do
        expected_feeds = JSON.parse(fixture('dummy_feeds.json'), object_class: OpenStruct).objects
        expect(feeds_api.feeds).to eq expected_feeds
      end

      it 'extracts uid data with #uids' do
        expected_uid = 'GS5vq3D3MvqUZmBqRQoQY9Av4KRgHPvs'
        expect(feeds_api.uids[0][:uid]).to eq expected_uid
      end
    end

    context 'for a specific uid' do
      it 'provides feed data' do
        feed_uid = 'n3TQUtzAp3c67BYOUsIuMAwgWe7i0r3A'
        expected_feed_data = JSON.parse(fixture('dummy_feed.json'), object_class: OpenStruct)

        stub_request(:get, Api::DEFAULT_API_URL + 'feeds/' + feed_uid + '/')
          .with(:headers => {'Authorization' => "Bearer #{token}"})
          .to_return(:body => fixture('dummy_feed.json'))

        expect(feeds_api.feed(feed_uid)).to eq expected_feed_data
      end
    end
  end
end

