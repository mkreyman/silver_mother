require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Api do
    before do
      allow(Api.instance).to receive(:log_request)
    end

    it 'performs all calls with authorization header' do
      api = Api.instance
      expected = instance_double(HTTParty::Response,
                                 success?: true,
                                 parsed_response: fixture('dummy_feed.json'))

      stub_request(:any, Api::DEFAULT_API_URL + 'path/to/resource')
        .with(:headers => {'Authorization' => 'Bearer stubbed-application-token',
                           'Content-Type' => 'application/json'})
        .to_return(:body => fixture('dummy_feed.json'))

      actual = api.get('path/to/resource',
                          'stubbed-application-token',
                           headers: {'Content-Type' => 'application/json'})

      expect(actual.parsed_response).to eq expected.parsed_response
    end
  end
end

