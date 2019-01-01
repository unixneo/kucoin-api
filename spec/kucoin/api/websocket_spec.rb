RSpec.describe Kucoin::Api::Websocket do
  before do
    stub_request(:any, described_class::USERCENTER_LOGIC_URL)
      .to_return(body: {
        "success": true,
        "code": "OK",
        "msg": "Operation succeeded",
        "timestamp": 1546336552778,
        "data": {
          "bulletToken": "gH1_HmSAwdh0FlOnGPyacf7xOiCpz54uLUUsvt_e5BPN4SuEe6JmkA==.o01w3FA7sVxx8_7RkrlO6g==",
          "instanceServers": [
            {
              "pingInterval": 40000,
              "endpoint": "wss://push1.kucoin.com/endpoint",
              "protocol": "websocket",
              "encrypt": true,
              "pingTimeout": 60000,
              "userType": "normal"
            },
            {
              "pingInterval": 40000,
              "endpoint": "wss://push1.kucoin.com/endpoint",
              "protocol": "websocket",
              "encrypt": true,
              "pingTimeout": 60000,
              "userType": "vip"
            }
          ],
          "historyServers": [
            {
              "endpoint": "https://kitchen.kucoin.com/v1/bullet/history",
              "encrypt": true,
              "userType": "vip"
            },
            {
              "endpoint": "https://kitchen.kucoin.com/v1/bullet/history",
              "encrypt": true,
              "userType": "normal"
            }
          ]
        }
      }.to_json)
    allow_any_instance_of(Kucoin::Api::Websocket).to receive(:endpoint).and_return('wss://0.0.0.0:3000/endpoint')
  end
  let(:market_symbol) { 'ETH-BTC' }
  let(:client) { Kucoin::Api::Websocket.new }
  let(:methods) do
    error = proc { |e| puts "ERROR : #{e.message}" }
    close = proc do
      puts "CLOSED #{market_symbol}"
      expect(true).to eq false
    end
    message = proc { |event| puts "MESSAGE : #{event.data}" }
    open = proc { puts "OPEN" }
    methods = { open: open, message: message, error: error, close: close }
  end

  it 'something', mock_kucoin_websocket_server: true do
    mock_websocket do
      client.tick symbol: market_symbol, methods: methods
    end
  end
end
