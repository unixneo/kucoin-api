# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Currency < Base
        def all options: {}
          open.ku_request :get, :all, options
        end

        def update currency
          auth.ku_request :post, :update, currency: currency
        end
      end
    end
  end
end
