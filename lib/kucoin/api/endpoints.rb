# frozen_string_literal: true
module Kucoin
  module Api
    ENDPOINTS = {
      currency: {
        all: 'v1/open/currencies',
        update: 'v1/user/change-currency'
      },
      language: {
        all: 'v1/open/lang-list',
        update: 'v1/user/change-lang'
      },
      user: {
        info: 'v1/user/info'
      }
    }
  end
end
