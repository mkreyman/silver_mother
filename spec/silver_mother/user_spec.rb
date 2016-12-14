require 'spec_helper'
require 'webmock/rspec'
require 'pry'

module SilverMother
  describe User do
    token = 'stubbed-application-token'
    users_api = SilverMother::User.instance

    before :all do
      stub_request(:get, SENSE_API_URL + 'user/')
        .with(:headers => {'Authorization' => "Bearer #{token}"})
        .to_return(:body => fixture('dummy_user.json'))

      users_api.call(token)
    end

    it 'pulls user data with #call' do
      expected_user_data = JSON.parse(fixture('dummy_user.json'), object_class: OpenStruct)
      expect(users_api.user).to eq expected_user_data
    end

    it 'displays user attributes' do
      expected_user_username      = 'user_dummy'
      expected_user_email         = 'user@example.com'
      expected_user_devices_label = 'node_dummy'

      expect(users_api.user.username).to eq expected_user_username
      expect(users_api.user.email).to eq expected_user_email
      expect(users_api.user.devices.label).to eq expected_user_devices_label
    end
  end
end
