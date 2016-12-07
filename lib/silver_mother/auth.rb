module SilverMother
  class Auth

    SENSE_URL      = 'https://sen.se/api/v2/'
    RESPONSE_TYPE  = 'code'
    GRANT_TYPE     = 'authorization_code'
    DEFAULTS_PATHS = {
                        authorization_path: 'oauth2/authorize/',
                        token_path:         'oauth2/token/',
                        refresh_path:       'oauth2/refresh/'
                      }

    attr_accessor :gateway_url,
                  :redirect_url,
                  :oauth2_client_id,
                  :oauth2_client_secret,
                  :scope,
                  :token

    def initialize(params={})
      @gateway_url          = params.fetch(:gateway_url)
      @redirect_url         = params.fetch(:redirect_url)
      @oauth2_client_id     = params.fetch(:oauth2_client_id)
      @oauth2_client_secret = params.fetch(:oauth2_client_secret)
      @scope                = params.fetch(:scope)
    end

    def authorization_url
      SENSE_URL +
      DEFAULTS_PATHS[:authorization_path] +
      '?client_id=' + oauth2_client_id +
      '&scope=' + scope +
      '&redirect_uri=' + html_encode(redirect_url) +
      '&response_type=' + RESPONSE_TYPE
    end

    def token
      @token = Api.instance.post(DEFAULTS_PATHS[:token_path], access_token_params).to_ostruct
    end

    def access_token_params(auth_code)
      {
        client_id: @oauth2_client_id,
        client_secret: @oauth2_client_secret,
        code: auth_code,
        redirect_uri: html_encode(@redirect_url),
        grant_type: GRANT_TYPE
      }
    end

    private

    def html_encode(url)
      CGI.escape(url)
    end
  end
end
