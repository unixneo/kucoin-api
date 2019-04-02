RSpec.describe Kucoin::Api::Endpoints::Order, type: :endpoint do
  describe '#all' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order?symbol=ETH-BTC' }
    let(:request_method)  { :post }
    let(:request_body)    { {} }
    it { expect(subject.create('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#active' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order/active?symbol=ETH-BTC' }
    it { expect(subject.active('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#active_kv' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order/active-map?symbol=ETH-BTC' }
    it { expect(subject.active_kv('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#cancel' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/cancel-order?symbol=ETH-BTC' }
    let(:request_method)  { :post }
    let(:request_body)    { {} }
    it { expect(subject.cancel('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#cancel_all' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order/cancel-all?symbol=ETH-BTC' }
    let(:request_method)  { :post }
    let(:request_body)    { {} }
    it { expect(subject.cancel_all('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#dealt' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order/dealt' }
    it { expect(subject.dealt).to eq({"foo"=>"bar"}) }
  end

  describe '#specific_dealt' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/deal-orders?symbol=ETH-BTC' }
    it { expect(subject.specific_dealt('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#all' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/orders?symbol=ETH-BTC' }
    it { expect(subject.all('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end

  describe '#detail' do
    let(:auth_request)    { true }
    let(:request_path)    { '/v1/order/detail?symbol=ETH-BTC' }
    it { expect(subject.detail('ETH-BTC')).to eq({"foo"=>"bar"}) }
  end
end
