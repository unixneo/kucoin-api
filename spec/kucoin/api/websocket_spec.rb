RSpec.describe Kucoin::Api::Websocket do
  before do
    stub_request(:get, described_class::USERCENTER_LOGIC_URL).to_return(body: acquire_websocket_servers_response.to_json)
  end
  let(:market_symbol) { 'ETH-BTC' }
  let(:client) { Kucoin::Api::Websocket.new }

  context '#orderbook' do
    let(:response_data) { {"id"=>client.id, "topic"=>"/trade/ETH-BTC_TRADE", "type"=>"subscribe"} }

    it 'return valid response' do
      mock_websocket_server do |mock_server|
        client.orderbook symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
      end
    end
  end

  context '#history' do
    let(:response_data) { {"id"=>client.id, "topic"=>"/trade/ETH-BTC_HISTORY", "type"=>"subscribe"} }

    it 'return valid response' do
      mock_websocket_server do |mock_server|
        client.history symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
      end
    end
  end

  context '#tick' do
    let(:response_data) { {"id"=>client.id, "topic"=>"/market/ETH-BTC_TICK", "type"=>"subscribe"} }

    it 'return valid response' do
      mock_websocket_server do |mock_server|
        client.tick symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
      end
    end
  end

  context '#market' do
    let(:response_data) { {"id"=>client.id, "topic"=>"/market/ETH-BTC", "type"=>"subscribe"} }

    it 'return valid response' do
      mock_websocket_server do |mock_server|
        client.market symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
      end
    end
  end
end
