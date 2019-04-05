RSpec.describe Kucoin::Api::Websocket do
  let(:request_url) { "#{Kucoin::Api::REST::BASE_URL}#{request_path}" }
  before do
    allow_any_instance_of(Object).to receive(:rand).and_return(981147906)
    stub_request(:post, request_url).to_return(body: acquire_websocket_servers_response.to_json)
  end
  let(:market_symbol) { 'ETH-BTC' }
  let(:client) { Kucoin::Api::Websocket.new }

  context 'Public topic' do
    let(:request_path) { '/api/v1/bullet-public' }

    context '#ticker' do
      let(:response_data) { {"id"=>981147906, "privateChannel"=>false, "response"=>true, "topic"=>"/market/ticker:ETH-BTC", "type"=>"subscribe"} }

      it 'return valid response' do
        mock_websocket_server do |mock_server|
          client.ticker symbols: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
        end
      end

      context 'multiple symbols' do
        let(:response_data) { {"id"=>981147906, "privateChannel"=>false, "response"=>true, "topic"=>"/market/ticker:ETH-BTC,KCS-BTC", "type"=>"subscribe"} }
        let(:market_symbol) { ['ETH-BTC', 'KCS-BTC'] }

        it 'return valid response' do
          mock_websocket_server do |mock_server|
            client.ticker symbols: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
          end
        end
      end
    end

    context '#all_ticker' do
      let(:response_data) { {"id"=>981147906, "privateChannel"=>false, "response"=>true, "topic"=>"/market/ticker:all", "type"=>"subscribe"} }

      it 'return valid response' do
        mock_websocket_server do |mock_server|
          client.all_ticker methods: mock_websocket_client_methods(mock_server, response_data)
        end
      end
    end

    context 'Private topic' do
      let(:request_path) { '/api/v1/bullet-private' }
    end
  end

  # TODO remove
  # context '#orderbook' do
  #   let(:response_data) { {"id"=>client.id, "topic"=>"/trade/ETH-BTC_TRADE", "type"=>"subscribe"} }
  #
  #   it 'return valid response' do
  #     mock_websocket_server do |mock_server|
  #       client.orderbook symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
  #     end
  #   end
  # end
  #
  # context '#history' do
  #   let(:response_data) { {"id"=>client.id, "topic"=>"/trade/ETH-BTC_HISTORY", "type"=>"subscribe"} }
  #
  #   it 'return valid response' do
  #     mock_websocket_server do |mock_server|
  #       client.history symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
  #     end
  #   end
  # end
  #
  # context '#tick' do
  #   let(:response_data) { {"id"=>client.id, "topic"=>"/market/ETH-BTC_TICK", "type"=>"subscribe"} }
  #
  #   it 'return valid response' do
  #     mock_websocket_server do |mock_server|
  #       client.tick symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
  #     end
  #   end
  # end
  #
  # context '#market' do
  #   let(:response_data) { {"id"=>client.id, "topic"=>"/market/ETH-BTC", "type"=>"subscribe"} }
  #
  #   it 'return valid response' do
  #     mock_websocket_server do |mock_server|
  #       client.market symbol: market_symbol, methods: mock_websocket_client_methods(mock_server, response_data)
  #     end
  #   end
  # end
end
