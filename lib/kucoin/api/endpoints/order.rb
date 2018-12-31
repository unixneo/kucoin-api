# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Order < Base
        def create symbol, options = {}
          auth.ku_request :post, :create, symbol: symbol, **options
        end

        def active options = {}
          auth.ku_request :get, :active, options
        end

        def active_kv options = {}
          auth.ku_request :get, :active_kv, options
        end

        def cancel symbol, options = {}
          auth.ku_request :post, :cancel, symbol: symbol, **options
        end

        def cancel_all symbol, options = {}
          auth.ku_request :post, :cancel_all, symbol: symbol, **options
        end

        def dealt options = {}
          auth.ku_request :get, :dealt, options
        end

        def deal options = {}
          auth.ku_request :get, :deal, options
        end

        def all options = {}
          auth.ku_request :get, :all, options
        end

        def detail options = {}
          auth.ku_request :get, :detail, options
        end
      end
    end
  end
end
