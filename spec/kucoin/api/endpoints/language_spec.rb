RSpec.describe Kucoin::Api::Endpoints::Language, type: :endpoint do
  describe '#all' do
    let(:request_url) { 'https://api.kucoin.com/v1/open/lang-list' }
    it { expect(subject.all).to eq({"foo"=>"bar"}) }
  end

  describe '#update' do
    let(:request_url)     { 'https://api.kucoin.com/v1/user/change-lang?lang=EN' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"lang\":\"EN\"}" }
    it { expect(subject.update('EN')).to eq({"foo"=>"bar"}) }
  end
end
