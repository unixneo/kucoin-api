# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Order < Base
        def create symbol, options = {}
          auth.ku_request :post, :create, symbol: symbol, **options
        end

        def active symbol, options = {}
          auth.ku_request :get, :active, symbol: symbol, **options
        end

        def active_kv symbol, options = {}
          auth.ku_request :get, :active_kv, symbol: symbol, **options
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

        def specific_dealt symbol, options = {}
          auth.ku_request :get, :specific_dealt, symbol: symbol, **options
        end

        def all symbol, options = {}
          auth.ku_request :get, :all, symbol: symbol, **options
        end

        def detail symbol, options = {}
          auth.ku_request :get, :detail, symbol: symbol, **options
        end
      end
    end
  end
end
