# Developing this in parallel with home-grown Auth for now...

require 'oauth2'

module SilverMother
  class Auth2

    SENSE_URL      = 'https://sen.se'
    DEFAULTS_PATHS = {
                        authorization_path: '/api/v2/oauth2/authorize/',
                        token_path:         '/api/v2/oauth2/token/',
                        refresh_path:       '/api/v2/oauth2/refresh/'
                      }

    attr_accessor :gateway_url,
                  :redirect_url,
                  :oauth2_client_id,
                  :oauth2_client_secret,
                  :scope,
                  :client,
                  :token

    def initialize(params={})
      @gateway_url          = params.fetch(:gateway_url)
      @redirect_url         = params.fetch(:redirect_url)
      @oauth2_client_id     = params.fetch(:oauth2_client_id)
      @oauth2_client_secret = params.fetch(:oauth2_client_secret)
      @scope                = params.fetch(:scope)
    end

    def client
      @client = OAuth2::Client.new(
        @oauth2_client_id,
        @oauth2_client_secret,
        authorize_url: DEFAULTS_PATHS[:authorization_path],
        token_url: DEFAULTS_PATHS[:token_path],
        site: SENSE_URL
        )
    end

    def authorization_url
      client.auth_code.authorize_url(redirect_uri: @redirect_url) +
        # A hack to prevent 'oauth2' from replacing '+' with '%2B' in the scope param.
        '&scope=' + @scope
    end

    def token(auth_code)
      @token = client.auth_code.get_token(auth_code, redirect_uri: @redirect_url)
    end
  end
end
