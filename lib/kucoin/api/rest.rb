# frozen_string_literal: true
module Kucoin
  module Api
    class REST
      BASE_URL          = 'https://openapi-v2.kucoin.com'.freeze
      SANDBOX_BASE_URL  = 'https://openapi-sandbox.kucoin.com'.freeze

      extend Kucoin::Api::Endpoints
      generate_endpoint_methods

      attr_reader :api_key, :api_secret, :api_passphrase
      attr_reader :adapter

      def initialize(
          api_key: Kucoin::Api.default_key, 
          api_secret: Kucoin::Api.default_secret, 
          api_passphrase: Kucoin::Api.default_passphrase, 
          adapter: Faraday.default_adapter, 
          sandbox: false
        )
        @api_key = api_key
        @api_secret = api_secret
        @api_passphrase = api_passphrase
        @adapter = adapter
        @sandbox = sandbox
      end

      def sandbox?; @sandbox == true end

      def base_url
        sandbox? ? SANDBOX_BASE_URL : BASE_URL
      end

      def open endpoint
        Connection.new(endpoint, url: base_url) do |conn|
          conn.request :json
          conn.response :json, content_type: 'application/json'
          conn.adapter adapter
        end
      end

      def auth endpoint
        Connection.new(endpoint, url: base_url) do |conn|
          conn.request :json
          conn.response :json, content_type: 'application/json'
          conn.use Kucoin::Api::Middleware::NonceRequest
          conn.use Kucoin::Api::Middleware::AuthRequest, api_key, api_secret, api_passphrase
          conn.adapter adapter
        end
      end
    end
  end
end
