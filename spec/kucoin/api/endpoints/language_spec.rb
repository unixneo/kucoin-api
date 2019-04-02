RSpec.describe Kucoin::Api::Endpoints::Language, type: :endpoint do
  describe '#all' do
    let(:request_path) { '/v1/open/lang-list' }
    it { expect(subject.all).to eq({"foo"=>"bar"}) }
  end

  describe '#update' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/user/change-lang' }
    let(:request_method)  { :post }
    let(:request_body)    { "{\"lang\":\"EN\"}" }
    it { expect(subject.update('EN')).to eq({"foo"=>"bar"}) }
  end
end
