# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Trade
        class Orders < Trade
          def index options={}
            auth.ku_request :get, :index, **options
          end
          alias all index
          alias list index

          def delete_all options={}
            auth.ku_request :delete, :delete_all, **options
          end
          alias cancel_all delete_all

          def recent
            auth.ku_request :get, :recent
          end

          def create client_oid, side, symbol, options={}
            options = { clientOid: client_oid, side: side, symbol: symbol }.merge(options)
            assert_required_param options, :side, side_types
            assert_param_is_one_of options, :type,  order_types if options.has_key?(:type)
            auth.ku_request :post, :create, **options
          end
          alias place create

          def show order_id
            auth.ku_request :get, :show, order_id: order_id
          end
          alias get show
          alias detail show

          def delete order_id
            auth.ku_request :delete, :delete, order_id: order_id
          end
          alias cancel delete
        end
      end
    end
  end
end
