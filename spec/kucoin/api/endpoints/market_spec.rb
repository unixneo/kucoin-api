RSpec.describe Kucoin::Api::Endpoints::Market, type: :endpoint do
  describe '#tick' do
    let(:request_path)     { '/v1/open/tick' }
    it { expect(subject.tick).to eq({"foo"=>"bar"}) }
  end

  describe '#orders' do
    let(:request_path)     { '/v1/open/orders?symbol=ETH-BTC' }
    it { expect(subject.orders('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#buy_orders' do
    let(:request_path)     { '/v1/open/orders-buy?symbol=ETH-BTC' }
    it { expect(subject.buy_orders('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#sell_orders' do
    let(:request_path)     { '/v1/open/orders-sell?symbol=ETH-BTC' }
    it { expect(subject.sell_orders('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#recent_deal_orders' do
    let(:request_path)     { '/v1/open/deal-orders?symbol=ETH-BTC' }
    it { expect(subject.recent_deal_orders('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#trading' do
    let(:request_path)     { '/v1/open/markets' }
    it { expect(subject.trading).to eq({"foo"=>"bar"}) }
  end

  describe '#trading_symbols' do
    let(:request_path)     { '/v1/market/open/symbols' }
    it { expect(subject.trading_symbols).to eq({"foo"=>"bar"}) }
  end

  describe '#trading_coins' do
    let(:request_path)     { '/v1/market/open/coins-trending' }
    it { expect(subject.trading_coins).to eq({"foo"=>"bar"}) }
  end

  describe '#kline' do
    let(:request_path)     { '/v1/open/kline?symbol=ETH-BTC' }
    it { expect(subject.kline('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#chart_config' do
    let(:request_path)     { '/v1/open/chart/config' }
    it { expect(subject.chart_config).to eq({"foo"=>"bar"}) }
  end

  describe '#chart_symbols' do
    let(:request_path)     { '/v1/open/chart/symbols?symbol=ETH-BTC' }
    it { expect(subject.chart_symbols('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#chart_history' do
    let(:request_path)     { '/v1/open/chart/history' }
    it { expect(subject.chart_history).to eq({"foo"=>"bar"}) }
  end

  describe '#coin_info' do
    let(:request_path)     { '/v1/market/open/coin-info?coin=BTC' }
    it { expect(subject.coin_info('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#coins' do
    let(:request_path)     { '/v1/market/open/coins' }
    it { expect(subject.coins).to eq({"foo"=>"bar"}) }
  end

  describe '#my_trading_symbols' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/market/symbols' }
    it { expect(subject.my_trading_symbols).to eq({"foo"=>"bar"}) }
  end

  describe '#stick_symbols' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/market/stick-symbols' }
    it { expect(subject.stick_symbols).to eq({"foo"=>"bar"}) }
  end

  describe '#favourite_symbols' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/market/fav-symbols' }
    it { expect(subject.favourite_symbols).to eq({"foo"=>"bar"}) }
  end

  describe '#stick_symbol' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/market/symbol/stick' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"symbol\":\"ETH-BTC\"}" }
    it { expect(subject.stick_symbol('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#favourite_symbol' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/market/symbol/fav' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"symbol\":\"ETH-BTC\"}" }
    it { expect(subject.favourite_symbol('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end
end
