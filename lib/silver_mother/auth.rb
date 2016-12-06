require 'singleton'

module SilverMother
  class Auth
    include Singleton

    DEFAULT_AUTH_URL = 'https://sen.se/api/v2/'

    def build_authorization_url
      DEFAULT_AUTH_URL +
      authorization_path +
      '?client_id=' + oauth2_client_id +
      '&scope=' + default_scope +
      '&redirect_uri=' + redirect_url +
      '&response_type=' + response_type +
      '&state=' + state
    end

    private

    def authorization_path
      'oauth2/authorize/'
    end

    def token_path
      'oauth2/token/'
    end

    def refresh_path
      'oauth2/refresh/'
    end

    def gateway_url
      ENV['GATEWAY_URL']
    end

    def redirect_url
      ENV['REDIRECT_URL']
    end

    def oauth2_client_id
      ENV['OAUTH2_CLIENT_ID']
    end

    def oauth2_client_secret
      ENV['OAUTH2_CLIENT_SECRET']
    end

    def default_scope
      ENV['DEFAULT_SCOPE']
    end

    def response_type
      'code'
    end

    def state
      '1245klj'
    end
  end
end
