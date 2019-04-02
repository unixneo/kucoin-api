# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Account < Base
        def list
          auth.ku_request :get, :list
        end

        def wallet_address coin
          auth.ku_request :get, :wallet_address, coin: coin
        end

        def wallet_records coin, options={}
          auth.ku_request :get, :wallet_records, coin: coin, **options
        end

        def withdraw coin, options={}
          auth.ku_request :post, :withdraw, coin: coin, **options
        end

        def cancel_withdraw coin, options={}
          auth.ku_request :post, :cancel_withdraw, coin: coin, **options
        end

        def balance coin
          auth.ku_request :get, :balance, coin: coin
        end

        def balances options={}
          auth.ku_request :get, :balances, options
        end
      end
    end
  end
end
