# frozen_string_literal: true
require 'json'
require 'faraday'
require 'faraday_middleware'
require 'faye/websocket'

require 'kucoin/api/version'
require 'kucoin/api/websocket'
require 'kucoin/api/rest'

module Kucoin
  module Api
    class Error < StandardError; end
  end
end
