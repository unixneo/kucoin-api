class MockWebsocketServer
  HOST      = '0.0.0.0'
  PORT      = 0
  attr_accessor :connections, :response_message

  def initialize
    @connections      = []
    @response_message = {}
  end

  def _endpoint
    port, host = Socket.unpack_sockaddr_in( EM.get_sockname( @signature ))
    "wss://#{host}:#{port}/endpoint"
  end

  def start
    @signature = EM.start_server(HOST, PORT, MockWebsocketConnection) do |mock_connection|
      self.connections << mock_connection
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
      logger.debug "[MockWebsocketServer] -- Waiting for #{@connections.size} connection(s) to finish ..."
      false
    end
  end
end

class MockWebsocketConnection < EventMachine::Connection
  attr_accessor :server
  attr_reader :driver

  def initialize
    @driver = WebSocket::Driver.server(self)

    driver.on(:connect) do |e|
      logger.debug '[WEBSOCKET - SERVER] CONNECT'
      driver.start if WebSocket::Driver.websocket? driver.env
    end
    driver.on(:message) do |e|
      logger.debug "[WEBSOCKET - SERVER] MESSAGE = #{e.data}"
      driver.frame(server.response_message.merge(data: JSON.parse(e.data)).to_json)
      close_connection_after_writing
    end
    driver.on(:close) do |e|
      logger.debug '[WEBSOCKET - SERVER] CLOSE'
      close_connection_after_writing
    end
  end

  def post_init
    logger.debug '[WEBSOCKET - SERVER] -- someone connected to the server!'
    start_tls(verify_peer: true)
  end

  def write(data)
    send_data(data)
  end

  def receive_data data
    driver.parse(data)
  end

  def unbind
    server.connections.delete(self)
  end
end

def mock_websocket_server response_message=nil, &block
  EM.run do
    mock_server = MockWebsocketServer.new
    mock_server.response_message = response_message || { foo: :bar }
    mock_server.start
    allow_any_instance_of(Kucoin::Api::Endpoints::Websocket::Response).to receive(:endpoint).and_return(mock_server._endpoint)
    block.call(mock_server)
  end
end

def mock_websocket_client_methods mock_server, response_message
  error   = proc { |e| logger.debug "[WEBSOCKET - CLIENT] ERROR : #{e.message}" }
  close   = proc { |e| logger.debug "[WEBSOCKET - CLIENT] CLOSED" }
  open    = proc { |e| logger.debug "[WEBSOCKET - CLIENT] OPEN" }
  message = proc do |e|
    logger.debug "[WEBSOCKET - CLIENT] : #{e.data}"
    expect(JSON.parse(e.data)['data']).to eq(response_message)
    mock_server.stop
  end
  { open: open, message: message, error: error, close: close }
end
