RSpec.describe Kucoin::Api::Endpoints::Markets::Tickers, type: :endpoint do
  describe '#index' do
    let(:request_path) { '/api/v1/market/allTickers' }
    it { expect(subject.index).to eq({"foo"=>"bar"}) }
  end

  describe '#inside' do
    let(:request_path) { '/api/v1/market/orderbook/level1?symbol=BTC-USDT' }
    it { expect(subject.inside('BTC-USDT')).to eq({"foo"=>"bar"}) }
  end
end
