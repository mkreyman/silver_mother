require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Subscription do
    token = 'stubbed-application-token'
    subscriptions_api = SilverMother::Subscription.instance

    before :all do
      stub_request(:get, Api::DEFAULT_API_URL + 'subscriptions/')
        .with(:headers => {'Authorization' => "Bearer #{token}"})
        .to_return(:body => fixture('dummy_subscriptions.json'))

      subscriptions_api.call(token)
    end

    context 'with all data' do
      it 'pulls raw subscriptions with #call' do
        expected_raw_subscription_data = fixture('dummy_subscriptions.json')
        expect(subscriptions_api.subscriptions_raw[0].parsed_response).to eq expected_raw_subscription_data
      end

      it 'extracts subscriptions data with #subscriptions' do
        expected_subscriptions = JSON.parse(fixture('dummy_subscriptions.json'), object_class: OpenStruct).objects
        expect(subscriptions_api.subscriptions).to eq expected_subscriptions
      end
    end
  end
end



