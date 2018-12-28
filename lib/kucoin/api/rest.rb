# frozen_string_literal: true
module Kucoin
  module Api
    class REST
      BASE_URL    = 'https://api.kucoin.com'.freeze
      API_KEY     = ENV['KUCOIN_API_KEY'].to_s
      API_SECRET  = ENV['KUCOIN_API_SECRET'].to_s

      attr_reader :api_key, :api_secret, :adapter

      def initialize api_key: API_KEY, api_secret: API_SECRET, adapter: Faraday.default_adapter
        @api_key = api_key
        @api_secret = api_secret
        @adapter = adapter
      end

      def account
        @account ||= Kucoin::Api::Endpoints::Account.new(self)
      end

      def currency
        @currency ||= Kucoin::Api::Endpoints::Currency.new(self)
      end

      def language
        @language ||= Kucoin::Api::Endpoints::Language.new(self)
      end

      def market
        @market ||= Kucoin::Api::Endpoints::Market.new(self)
      end

      def order
        @order ||= Kucoin::Api::Endpoints::Order.new(self)
      end

      def user
        @user ||= Kucoin::Api::Endpoints::User.new(self)
      end

      def open endpoint
        Connection.new(endpoint, url: BASE_URL) do |conn|
          conn.request :json
          conn.response :json, content_type: 'application/json'
          conn.adapter adapter
        end
      end

      def auth endpoint
        Connection.new(endpoint, url: BASE_URL) do |conn|
          conn.request :json
          conn.response :json, content_type: 'application/json'
          conn.use Kucoin::Api::Middleware::NonceRequest
          conn.use Kucoin::Api::Middleware::AuthRequest, api_key, api_secret
          conn.adapter adapter
        end
      end
    end
  end
end
