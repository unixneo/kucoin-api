class MockWebsocketServer
  HOST      = '0.0.0.0'
  PORT      = '3000'
  ENDPOINT  = "wss://#{HOST}:#{PORT}/endpoint"
  attr_accessor :connections

  def initialize
    @connections = []
  end

  def start
    @signature = EM.start_server(HOST, PORT, MockWebsocketConnection) do |mock_connection|
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
    @request = WebSocket::HTTP::Request.new
    start_tls(verify_peer: true)
  end

  def receive_data data
    @request.parse(data)
    return unless @request.complete?
    headers = ['Upgrade: websocket', 'Connection: Upgrade']
    start = "HTTP/1.1 200 OK"
    result = [start, headers.join("\r\n"), '']
    send_data result.join("\r\n")
  end

  def ssl_handshake_completed
    headers = ['Upgrade: websocket', 'Connection: Upgrade']
    start = "HTTP/1.1 101 OK"
    result = [start, headers.join("\r\n")]
    send_data result.join("\r\n")
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
