class MockWebsocketServer
  attr_accessor :connections

  def initialize
    @connections = []
  end

  def start
    @signature = EM.start_server('0.0.0.0', 3000, MockWebsocketConnection) do |mock_connection|
      mock_connection.server = self
    end
  end

  def stop
    EM.stop_server(@signature)

    unless wait_for_connections_and_stop
      # Still some connections running, schedule a check later
      EM.add_periodic_timer(1) { wait_for_connections_and_stop }
    end
  end

  def wait_for_connections_and_stop
    if @connections.empty?
      EM.stop
      true
    else
      puts "-- Waiting for #{@connections.size} connection(s) to finish ..."
      false
    end
  end
end

class MockWebsocketConnection < EM::Connection
  attr_accessor :server

  def post_init
    puts "-- connected mock server!"
    @request = WebSocket::HTTP::Request.new
    start_tls(:verify_peer => true)
  end

  def receive_data data
    @request.parse(data)
    return unless @request.complete?
    puts "-- data #{data}"
    # unless @request.env['REQUEST_METHOD'] == 'CONNECT'
    #   puts "-- +++"
    #   send_data("HTTP/1.1 403 Forbidden\r\n\r\n")
    #   return close_connection_after_writing
    # end
    headers = ['Upgrade: websocket', 'Connection: Upgrade']
    start = "HTTP/1.1 200 OK"
    result = [start, headers.join('\r\n'), '']
    send_data result
  end

  def ssl_handshake_completed
    headers = ['Upgrade: websocket', 'Connection: Upgrade']
    start = "HTTP/1.1 101 OK"
    result = [start, headers.join('\r\n')]
    send_data result
  end

  def unbind
    server.connections.delete(self)
  end
end

def mock_websocket &block
  EM.run do
    @mock_server = MockWebsocketServer.new
    @mock_server.start
    block.call
    @mock_server.stop
  end
end
