# frozen_string_literal: true
module Kucoin
  module Api
    ENDPOINTS = {
      currency: {
        all:               'v1/open/currencies',
        update:            'v1/user/change-currency'
      },
      language: {
        all:               'v1/open/lang-list',
        update:            'v1/user/change-lang'
      },
      user: {
        info:              'v1/user/info'
      },
      account: {
        wallet_address:    'v1/account/:coin/wallet/address',
        wallet_records:    'v1/account/:coin/wallet/records',
        withdraw:          'v1/account/:coin/withdraw/apply',
        cancel_withdraw:   'v1/account/:coin/withdraw/cancel',
        balance:           'v1/account/:coin/balance',
        balances:          'v1/account/balances',
      },
      order: {
        create:            'v1/order?symbol=:symbol',
        active:            'v1/order/active',
        active_kv:         'v1/order/active-map',
        cancel:            'v1/cancel-order?symbol=:symbol',
        cancel_all:        'v1/order/cancel-all?symbol=:symbol',
        dealt:             'v1/order/dealt',
        deal:              'v1/deal-orders',
        all:               'v1/orders',
        detail:            'v1/order/detail',
      },
      # market: {
      #   tick:              'v1/open/tick',
      #   orders:            'v1/open/orders',
      #   buy_orders:        'v1/open/orders-buy',
      #   sell_orders:       'v1/open/orders-sell',
      #   deal_orders:       'v1/open/deal-orders',
      #   trading:           'v1/open/markets',
      #   trading_symbols:   'v1/market/open/symbols',
      #   trading_symbols:   'v1/market/open/coins-trending',
      #   trading_symbols:   'v1/open/kline',
      #   trading_symbols:   'v1/open/chart/config',
      #   trading_symbols:   'v1/open/chart/symbols',
      #   trading_symbols:   'v1/open/chart/history',
      #   trading_symbols:   'v1/market/open/coin-info',
      #   trading_symbols:   'v1/market/open/coins',
      #   # auth
      #   trading_symbols:   'v1/market/symbols',
      #   stick_symbols:     'v1/market/stick-symbols',
      #   fav_symbols:       'v1/market/fav-symbols',
      #   stick_symbol:      'v1/market/symbol/fav',
      #   fav_symbol:        'v1/market/symbol/stick',
      # }
    }
  end
end
