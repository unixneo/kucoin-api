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

require 'kucoin/api/endpoints'
Dir[File.expand_path('api/endpoints/*.rb', File.dirname(__FILE__))].each {|file| require file }

require 'kucoin/api/rest'
require 'kucoin/api/rest/connection'

module Kucoin
  module Api; end
end
