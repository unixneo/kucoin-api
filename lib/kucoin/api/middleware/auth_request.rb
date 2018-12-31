# frozen_string_literal: true
module Kucoin
  module Api
    module Middleware
      class AuthRequest < Faraday::Middleware
        def initialize app, api_key, api_secret
          super(app)
          @api_key = api_key.to_s
          @api_secret = api_secret.to_s
        end

        def call env
          raise Kucoin::Api::MissingApiKeyError.new('API KEY not provided') if @api_key.empty?
          raise Kucoin::Api::MissingApiSecretError.new('API SECRET not provided') if @api_secret.empty?
          env[:request_headers]['KC-API-KEY'] = @api_key
          env[:request_headers]['KC-API-SIGNATURE'] = signature(env)
          env.url.query = query_string(env)
          @app.call env
        end

        private

        def signature env
          signature_str = Base64.strict_encode64(str_for_sign(env))
          OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @api_secret, signature_str)
        end

        def str_for_sign env
          "#{env.url.path}/#{env[:request_headers]['KC-API-NONCE']}/#{query_string(env)}"
        end

        def query_string env
          return @query_string if @query_string
          params = ::Hash[URI.decode_www_form(env.url.query.to_s)]
          begin
            params.merge!(::JSON.parse(env.body.to_s))
          rescue JSON::ParserError => e
          end
          URI.encode_www_form(params.sort)
        end
      end
    end
  end
end
