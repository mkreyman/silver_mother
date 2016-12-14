module SilverMother
  class Auth

    SENSE_URL      = 'https://sen.se/api/v2/'
    RESPONSE_TYPE  = 'code'
    GRANT_TYPES    = {
                       access: 'authorization_code',
                       refresh: 'refresh_token'
                     }

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
      url_params = {
                     client_id:     @oauth2_client_id,
                     scope:         @scope,
                     redirect_uri:  html_encode(@redirect_url),
                     response_type: RESPONSE_TYPE
                    }.map { |k, v| "#{k.to_s}=#{v}" }.join('&')

      SENSE_URL + DEFAULTS_PATHS[:authorization_path] + '?' + url_params
    end

    def get_token(auth_code)
      @token = Api.instance.post(
        DEFAULTS_PATHS[:token_path], nil, url_encoded_params(auth_code, :access)
        ).to_ostruct
      @token.expires_on = ttl(@token.expires_in)
      @token
    end

    def refresh_token(refresh_token)
      @token = Api.instance.post(
        DEFAULTS_PATHS[:refresh_path], nil, url_encoded_params(refresh_token, :refresh)
        ).to_ostruct
      @token.expires_on = ttl(@token.expires_in)
      @token
    end

    def expired?
      Time.now.to_i > @token.expires_on.to_i
    end

    private

    def url_encoded_params(code, grant_type)
      case grant_type
      when :access
        params = {
          client_id:     @oauth2_client_id,
          client_secret: @oauth2_client_secret,
          code:          code,
          redirect_uri:  html_encode(@redirect_url),
          grant_type:    GRANT_TYPES[grant_type]
        }
      when :refresh
        params = {
          refresh_token: code,
          grant_type: GRANT_TYPES[grant_type]
        }
      else
        fail 'Unsupported grant type'
      end

      url_encoded_body = params.map { |k, v| "#{k.to_s}=#{v}" }.join('&')
      header = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      { body: url_encoded_body, headers: header }
    end

    def ttl(secs)
      Time.now.to_i + secs.to_i
    end

    def html_encode(url)
      CGI.escape(url)
    end
  end
end
