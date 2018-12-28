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
          env[:request_headers]["KC-API-KEY"] = @api_key

          # TODO : Signature Calculation
          #  https://kucoinapidocs.docs.apiary.io/#introduction/authentication/signature-calculation
          # env[:request_headers]["KC-API-SIGNATURE"] = @api_key
          # hash = OpenSSL::HMAC.hexdigest(
          #   OpenSSL::Digest.new('sha256'), secret_key, env.url.query
          # )
          # env.url.query = REST.add_query_param(env.url.query, 'signature', hash)

          @app.call env
        end
      end
    end
  end
end
