RSpec.describe Kucoin::Api::Websocket do
  before do
    stub_request(:get, described_class::USERCENTER_LOGIC_URL).to_return(body: acquire_websocket_servers_response.to_json)
    allow_any_instance_of(Kucoin::Api::Websocket).to receive(:endpoint).and_return(MockWebsocketServer::ENDPOINT)
  end
  let(:market_symbol) { 'ETH-BTC' }
  let(:client) { Kucoin::Api::Websocket.new }
  let(:methods) do
    error = proc { |e| puts "ERROR : #{e.message}" }
    close = proc do
      puts "CLOSED #{market_symbol}"
    end
    message = proc { |event| puts "MESSAGE : #{event.data}" }
    open = proc { puts "OPEN" }
    methods = { open: open, message: message, error: error, close: close }
  end

  # TODO : mocking Websocket servers
  context '#tick' do
    xit 'return valid response', mock_kucoin_websocket_server: true do
      mock_websocket do
        client.tick symbol: market_symbol, methods: methods
        expect(true).to eq false
      end
    end
  end
end
