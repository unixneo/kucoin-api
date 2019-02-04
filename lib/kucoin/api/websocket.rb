# frozen_string_literal: true

module Kucoin
  module Api
    class Websocket
      USERCENTER_LOGIC_URL = 'https://kitchen.kucoin.com/v1/bullet/usercenter/loginUser?protocol=websocket&encrypt=true'.freeze

      attr_reader :bullet_token, :endpoint, :id, :ping_interval

      def initialize
        response = Faraday.get(USERCENTER_LOGIC_URL)
        if response.status == 200
          data = JSON.parse(response.body)["data"]
          @bullet_token = data["bulletToken"]
          @endpoint = data["instanceServers"][0]["endpoint"]
          @id = rand Time.now.to_i
          @ping_interval = data["instanceServers"][0]["pingInterval"]
        end
      end

      # Public: Create a WebSocket stream
      #
      # :stream - The Hash used to define the stream
      #   :topic    - The String channel to listen to
      #
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def start stream:, methods:
        channel = create_stream("#{endpoint}?bulletToken=#{bullet_token}&format=json&resource=api", methods: methods)
        params = {id: id, type: "subscribe", topic: stream[:topic]}
        channel.send(params.to_json)
        return channel
      end

      # We can subscribe "/trade/{symbol}_TRADE" to get orderbook level2
      # incremental data. {symbol} can be replaced by ETH-BTC or BTC-USDT and
      # so on. We need to get the initial data through the REST API before we
      # can process the incremental data. In the future, we will limit REST
      # API access frequency to 5 times per second per single IP.
      #
      # {"id":123, "type":"subscribe", "topic":"/trade/ETH-BTC_TRADE", "req":1}
      def orderbook symbol:, methods:
        start stream: { topic: "/trade/#{symbol}_TRADE" }, methods: methods
      end

      # We can subscribe "/trade/{symbol}_HISTORY" to get history info.
      # {symbol} can be replaced by ETH-BTC or BTC-USDT and so on. We need to
      # get the initial data through the REST API before we can process the
      # incremental data. In the future, we will limit REST API access
      # frequency to 5 times per second per single IP.
      #
      # {"id":123, "type":"subscribe", "topic":"/trade/ETH-BTC_HISTORY", "req":1}
      def history symbol:, methods:
        start stream: { topic: "/trade/#{symbol}_HISTORY" }, methods: methods
      end

      # TickWe can subscribe "/market/{symbol}_TICK" to get history info.
      # {symbol} can be replaced by ETH-BTC or BTC-USDT and so on. We need to
      # get the initial data through the REST API before we can process the
      # incremental data. In the future, we will limit REST API access
      # frequency to 5 times per second per single IP
      #
      # {"id":123, "type":"subscribe", "topic":"/market/ETH-BTC_TICK", "req":1}
      def tick symbol:, methods:
        start stream: { topic: "/market/#{symbol}_TICK" }, methods: methods
      end

      # We can subscribe "/market/{market}" to get history info. {market} can
      # be replaced by ETH or USDT and so on. We need to get the initial data
      # through the REST API before we can process the incremental data. In
      # the future, we will limit REST API access frequency to 5 times per
      # second per single IP.
      #
      # {"id":123, "type":"subscribe", "topic":"/market/BTC", "req":1}
      def market symbol:, methods:
        start stream: { topic: "/market/#{symbol}" }, methods: methods
      end

      private

      # Internal: Initialize and return a Faye::WebSocket::Client
      #
      # url - The String url that the WebSocket should try to connect to
      #
      # :methods - The Hash which contains the event handler methods to pass to
      #            the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def create_stream url, methods:
        Faye::WebSocket::Client.new(url, [], ping: ping_interval).tap { |ws| attach_methods(ws, methods) }
      end

      # Internal: Iterate through methods passed and add them to the WebSocket
      #
      # websocket - The Faye::WebSocket::Client to apply methods to
      #
      # methods - The Hash which contains the event handler methods to pass to
      #   the WebSocket client
      #   :open    - The Proc called when a stream is opened (optional)
      #   :message - The Proc called when a stream receives a message
      #   :error   - The Proc called when a stream receives an error (optional)
      #   :close   - The Proc called when a stream is closed (optional)
      def attach_methods websocket, methods
        methods.each_pair do |key, method|
          websocket.on(key) { |event| method.call(event) }
        end
      end
    end
  end
end
