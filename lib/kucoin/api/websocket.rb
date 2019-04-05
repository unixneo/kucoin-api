# frozen_string_literal: true

module Kucoin
  module Api
    class Websocket
      attr_reader :rest_client

      def initialize rest_client: Kucoin::Api::REST.new
        @rest_client = rest_client
      end

      def open_stream methods:
        create_stream(rest_client.websocket.public, methods: methods)
      end

      def auth_stream methods:
        create_stream(rest_client.websocket.private, methods: methods)
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
        stream = { id: rand(Time.now.to_i), privateChannel: false, response: true }.merge(stream)
        channel = stream[:privateChannel] ? auth_stream(methods: methods) : open_stream(methods: methods)
        params = {id: stream[:id], type: 'subscribe', topic: stream[:topic], privateChannel: stream[:privateChannel], response: stream[:response]}
        channel.send(params.to_json)
        return channel
      end

      def ticker symbols:, methods:
        start stream: { topic: topic_path('/market/ticker', symbols) }, methods: methods
      end

      def all_ticker methods:
        ticker symbols: :all, methods: methods
      end

      def stop_order_received_event symbols: , methods:
        start stream: { topic: topic_path('/market/level3', symbols) }, methods: methods
      end

      def stop_order_activate_event symbols: , methods:
        start stream: { topic: topic_path('/market/level3', symbols) }, methods: methods
      end

      def balance methods:
        start stream: { topic: '/account/balance', privateChannel: true }, methods: methods
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
      def create_stream response, methods:
        Faye::WebSocket::Client.new("#{response.endpoint}?token=#{response.token}", [], ping: response.ping_interval).tap { |ws| attach_methods(ws, methods) }
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

      def topic_path path, values=[]
        values = [values] unless values.is_a?(Array)
        "#{path}:#{values.compact.join(',')}"
      end
    end
  end
end
