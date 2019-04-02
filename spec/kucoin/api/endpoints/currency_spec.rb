RSpec.describe Kucoin::Api::Endpoints::Currency, type: :endpoint do
  describe '#all' do
    let(:request_path) { '/api/v1/currencies' }
    it { expect(subject.all).to eq({"foo"=>"bar"}) }
  end

  describe '#update' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/user/change-currency' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"currency\":\"USD\"}" }
    it { expect(subject.update('USD')).to eq({"foo"=>"bar"}) }
  end
end
