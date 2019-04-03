RSpec.describe Kucoin::Api::Endpoints::Markets::Currencies, type: :endpoint do
  describe '#index' do
    let(:request_path) { '/api/v1/currencies' }
    it { expect(subject.index).to eq({"foo"=>"bar"}) }
  end

  describe '#fiat' do
    let(:request_path) { '/api/v1/prices' }
    it { expect(subject.fiat).to eq({"foo"=>"bar"}) }
  end

  describe '#show' do
    let(:request_path) { '/api/v1/currencies/BTC' }
    it { expect(subject.show('BTC')).to eq({"foo"=>"bar"}) }
  end
end
