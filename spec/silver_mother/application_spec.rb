require 'spec_helper'
require 'webmock/rspec'

module SilverMother
  describe Application do
    app_params = { gateway_url: 'http://localhost:3000/notification/',
                   redirect_url: 'http://localhost:3000/oauth/',
                   oauth2_client_id: 'stubbed-application-id',
                   oauth2_client_secret: 'stubbed-application-secret',
                   scope: 'profile+feeds.read' }

    app = Application.new(app_params)
    headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

    it 'creates an instance from a params hash' do
      expect(app.gateway_url).to eq app_params[:gateway_url]
      expect(app.redirect_url).to eq app_params[:redirect_url]
      expect(app.oauth2_client_id).to eq app_params[:oauth2_client_id]
      expect(app.oauth2_client_secret).to eq app_params[:oauth2_client_secret]
      expect(app.scope).to eq app_params[:scope]
    end

    it 'constructs a proper authorization url' do
      expected_url = 'https://sen.se/api/v2/oauth2/authorize/' \
                     '?client_id=stubbed-application-id' \
                     '&scope=profile+feeds.read' \
                     '&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Foauth%2F' \
                     '&response_type=code'

      expect(app.authorization_url).to eq expected_url
    end

    it 'can retrieve access token from authorization code' do
      auth_code = 'stubbed-authorization-code'
      expected_auth_object = JSON.parse(fixture('dummy_auth_object.json'),
                                        object_class: OpenStruct)

      stub_request(:post, 'https://apis.sen.se/v2/oauth2/token/')
        .with(body: { 'client_id' => 'stubbed-application-id',
                      'client_secret' => 'stubbed-application-secret',
                      'code' => 'stubbed-authorization-code',
                      'grant_type' => 'authorization_code',
                      'redirect_uri' => 'http://localhost:3000/oauth/' },
              headers: headers)
        .to_return(status: 200, body: fixture('dummy_auth_object.json'))

      app.get_token(auth_code).delete_field('expires_on')
      expect(app.token).to eq expected_auth_object
    end

    it 'can retrieve access token from refresh code' do
      refresh_code = 'stubbed-refresh-code'
      expected_auth_object = JSON.parse(fixture('dummy_auth_object.json'),
                                        object_class: OpenStruct)

      stub_request(:post, 'https://apis.sen.se/v2/oauth2/refresh/')
        .with(body: { 'grant_type' => 'refresh_token',
                      'refresh_token' => 'stubbed-refresh-code' },
              headers: headers)
        .to_return(status: 200, body: fixture('dummy_auth_object.json'))

      app.refresh_token(refresh_code).delete_field('expires_on')
      expect(app.token).to eq expected_auth_object
    end
  end
end
