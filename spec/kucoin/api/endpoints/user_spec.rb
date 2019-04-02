RSpec.describe Kucoin::Api::Endpoints::User, type: :endpoint do
  describe '#all' do
    let(:auth_request)  { true }
    let(:request_path)   { '/v1/user/info' }
    it { expect(subject.info).to eq({"foo"=>"bar"}) }
  end
end
