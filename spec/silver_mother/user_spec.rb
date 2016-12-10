require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Api do
    user = User.new('username', 'password')

    it 'returns user token' do
      expected_token = 'stubbed-user-token'
      user_params = {username: 'username', password: 'password'}

      stub_request(:post, Api::DEFAULT_API_URL + 'user/api_key/')
        .with(:body => user_params,
              :headers => {'Content-Type' => 'application/json'})
        .to_return(body: fixture('dummy_token.json'))

      expect(user.token).to eq expected_token
    end

    it 'returns user object' do
      expected_user_data = JSON.parse(fixture('dummy_user.json'), object_class: OpenStruct)

      stub_request(:get, Api::DEFAULT_API_URL + 'user/')
        .with(:headers => {'Authorization' => 'Token stubbed-user-token'})
        .to_return(:body => fixture('dummy_user.json'))

      expect(user.data).to eq expected_user_data
    end
  end
end
