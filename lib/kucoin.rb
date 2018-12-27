# frozen_string_literal: true
require 'json'
require 'oj'
require 'faraday'
require 'faraday_middleware'
require 'faye/websocket'

require 'kucoin/version'
require 'kucoin/client'
require 'kucoin/client/websocket'
require 'kucoin/client/rest'

module Kucoin
  class Error < StandardError; end
end
