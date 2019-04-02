# frozen_string_literal: true
module Kucoin
  module Api
    ENDPOINTS = {
      currency: {
        all:                'api/v1/currencies',
        update:             'v1/user/change-currency'
      },
      language: {
        all:                'v1/open/lang-list',
        update:             'v1/user/change-lang'
      },
      user: {
        info:               'v1/user/info'
      },
      account: {
        list:               'api/v1/accounts',
        wallet_address:     'v1/account/:coin/wallet/address',
        wallet_records:     'v1/account/:coin/wallet/records',
        withdraw:           'v1/account/:coin/withdraw/apply',
        cancel_withdraw:    'v1/account/:coin/withdraw/cancel',
        balance:            'v1/account/:coin/balance',
        balances:           'v1/account/balances',
      },
      order: {
        create:             'v1/order?symbol=:symbol',
        active:             'v1/order/active',
        active_kv:          'v1/order/active-map',
        cancel:             'v1/cancel-order?symbol=:symbol',
        cancel_all:         'v1/order/cancel-all?symbol=:symbol',
        dealt:              'v1/order/dealt',
        specific_dealt:     'v1/deal-orders',
        all:                'v1/orders',
        detail:             'v1/order/detail',
      },
      market: {
        # open
        tick:               'v1/open/tick',
        orders:             'v1/open/orders',
        buy_orders:         'v1/open/orders-buy',
        sell_orders:        'v1/open/orders-sell',
        recent_deal_orders: 'v1/open/deal-orders',
        trading:            'v1/open/markets',
        trading_symbols:    'v1/market/open/symbols',
        trading_coins:      'v1/market/open/coins-trending',
        kline:              'v1/open/kline',
        chart_config:       'v1/open/chart/config',
        chart_symbols:      'v1/open/chart/symbols',
        chart_history:      'v1/open/chart/history',
        coin_info:          'v1/market/open/coin-info',
        coins:              'v1/market/open/coins',
        # auth
        my_trading_symbols: 'v1/market/symbols',
        stick_symbols:      'v1/market/stick-symbols',
        favourite_symbols:  'v1/market/fav-symbols',
        favourite_symbol:   'v1/market/symbol/fav',
        stick_symbol:       'v1/market/symbol/stick',
      },
      other: {
        timestamp:          '/api/v1/timestamp'
      }
    }
    module Endpoints
      def self.get_klass name
        Object.const_get("Kucoin::Api::Endpoints::#{name.to_s.split('_').map(&:capitalize).join}")
      end
    end
  end
end
