module SilverMother
  class Application
    SENSE_URL      = 'https://sen.se/api/v2/'.freeze
    RESPONSE_TYPE  = 'code'.freeze
    GRANT_TYPES    = { access: 'authorization_code',
                       refresh: 'refresh_token' }.freeze

    DEFAULTS_PATHS = { authorization_path: 'oauth2/authorize/',
                       token_path:         'oauth2/token/',
                       refresh_path:       'oauth2/refresh/' }.freeze

    attr_accessor :gateway_url,
                  :redirect_url,
                  :oauth2_client_id,
                  :oauth2_client_secret,
                  :scope,
                  :token

    def initialize(params = {})
      @gateway_url          = params.fetch(:gateway_url)
      @redirect_url         = params.fetch(:redirect_url)
      @oauth2_client_id     = params.fetch(:oauth2_client_id)
      @oauth2_client_secret = params.fetch(:oauth2_client_secret)
      @scope                = params.fetch(:scope)
    end

    def authorization_url
      url_params = { client_id:     @oauth2_client_id,
                     scope:         @scope,
                     redirect_uri:  html_encode(@redirect_url),
                     response_type: RESPONSE_TYPE }
                   .map { |k, v| "#{k}=#{v}" }.join('&')

      SENSE_URL + DEFAULTS_PATHS[:authorization_path] + '?' + url_params
    end

    def get_token(auth_code)
      @token = Api.instance
                  .post(DEFAULTS_PATHS[:token_path],
                        nil,
                        url_encoded_params(auth_code, :access))
                  .to_ostruct

      @token.expires_on = ttl(@token.expires_in)
      @token
    end

    def refresh_token(refresh_token)
      @token = Api.instance
                  .post(DEFAULTS_PATHS[:refresh_path],
                        nil,
                        url_encoded_params(refresh_token, :refresh))
                  .to_ostruct

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
        params = params_for_access(code)
      when :refresh
        params = params_for_refresh(code)
      else
        raise 'Unsupported grant type'
      end

      { body: url_encode(params),
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' } }
    end

    def ttl(secs)
      Time.now.to_i + secs.to_i
    end

    def html_encode(url)
      CGI.escape(url)
    end

    def url_encode(params)
      params.map { |k, v| "#{k}=#{v}" }.join('&')
    end

    def params_for_access(code)
      { client_id:     @oauth2_client_id,
        client_secret: @oauth2_client_secret,
        code:          code,
        redirect_uri:  html_encode(@redirect_url),
        grant_type:    GRANT_TYPES[:access] }
    end

    def params_for_refresh(code)
      { refresh_token: code,
        grant_type: GRANT_TYPES[:refresh] }
    end
  end
end
