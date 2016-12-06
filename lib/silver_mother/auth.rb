module SilverMother
  class Auth

    DEFAULT_AUTH_URL = 'https://sen.se/api/v2/'

    attr_accessor :gateway_url,
                  :redirect_url,
                  :oauth2_client_id,
                  :oauth2_client_secret,
                  :scope,
                  :auth_code,
                  :token

    def initialize(options={})
      @gateway_url          = options.fetch(:gateway_url)
      @redirect_url         = options.fetch(:redirect_url)
      @oauth2_client_id     = options.fetch(:oauth2_client_id)
      @oauth2_client_secret = options.fetch(:oauth2_client_secret)
      @scope                = options.fetch(:scope)
    end

    def authorization_url
      DEFAULT_AUTH_URL +
      authorization_path +
      '?client_id=' + oauth2_client_id +
      '&scope=' + scope +
      '&redirect_uri=' + html_encode(redirect_url) +
      '&response_type=' + response_type
    end

    def auth_code(params)
      @auth_code = params['code']
    end

    def token
      @token = Api.instance.post(token_path, access_token_params).to_ostruct
    end

    private

    def access_token_params
      {
        client_id: @oauth2_client_id,
        client_secret: @oauth2_client_secret,
        code: @auth_code,
        redirect_uri: html_encode(@redirect_url),
        grant_type: 'authorization_code'
      }
    end

    def authorization_path
      'oauth2/authorize/'
    end

    def token_path
      'oauth2/token/'
    end

    def refresh_path
      'oauth2/refresh/'
    end

    def response_type
      'code'
    end

    def html_encode(url)
      CGI.escape(url)
    end
  end
end
