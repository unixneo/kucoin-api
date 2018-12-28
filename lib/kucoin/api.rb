# frozen_string_literal: true
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'faye/websocket'

require 'kucoin/api/version'
require 'kucoin/api/error'

require 'kucoin/api/middleware/auth_request'
require 'kucoin/api/middleware/nonce_request'

require 'kucoin/api/websocket'

require 'kucoin/api/rest'
require 'kucoin/api/rest/connection'

require 'kucoin/api/endpoints'
require 'kucoin/api/endpoints/base'
require 'kucoin/api/endpoints/account'
require 'kucoin/api/endpoints/currency'
require 'kucoin/api/endpoints/language'
require 'kucoin/api/endpoints/market'
require 'kucoin/api/endpoints/order'
require 'kucoin/api/endpoints/user'

module Kucoin
  module Api; end
end
