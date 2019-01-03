RSpec.describe Kucoin::Api::Endpoints::Currency, type: :endpoint do
  describe '#all' do
    let(:request_url) { 'https://api.kucoin.com/v1/open/currencies' }
    it { expect(subject.all).to eq({"foo"=>"bar"}) }
  end

  describe '#update' do
    let(:request_url)     { 'https://api.kucoin.com/v1/user/change-currency?currency=USD' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"currency\":\"USD\"}" }
    it { expect(subject.update('USD')).to eq({"foo"=>"bar"}) }
  end
end
