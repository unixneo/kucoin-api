RSpec.describe Kucoin::Api::Endpoints::Account, type: :endpoint do
  describe '#wallet_address' do
    let(:auth_request)  { true }
    let(:request_path)  { '/api/v1/accounts' }
    it { expect(subject.list).to eq({"foo"=>"bar"}) }
  end

  describe '#wallet_address' do
    let(:auth_request)  { true }
    let(:request_path)  { '/v1/account/BTC/wallet/address' }
    it { expect(subject.wallet_address('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#wallet_records' do
    let(:auth_request) { true }
    let(:request_path) { '/v1/account/BTC/wallet/records' }
    it { expect(subject.wallet_records('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#withdraw' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/account/BTC/withdraw/apply' }
    let(:request_method)  { :post }
    let(:request_body)    { {} }
    it { expect(subject.withdraw('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#cancel_withdraw' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/account/BTC/withdraw/cancel' }
    let(:request_method)  { :post }
    let(:request_body)    { {} }
    it { expect(subject.cancel_withdraw('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#balance' do
    let(:auth_request)  { true }
    let(:request_path)  { '/v1/account/BTC/balance' }
    it { expect(subject.balance('BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#balances' do
    let(:auth_request)  { true }
    let(:request_path)  { '/v1/account/balances' }
    it { expect(subject.balances).to eq({"foo"=>"bar"}) }
  end
end
