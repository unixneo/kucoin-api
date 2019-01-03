RSpec.describe Kucoin::Api::Endpoints::Base do
  let(:client) { Kucoin::Api::REST.new }
  let(:endpoint) { described_class.new(client) }
  subject { endpoint }

  it { expect(subject.client).to eq client }
  context '#open' do
    it { expect(client).to receive(:open).with(subject); subject.open }
  end

  context '#auth' do
    it { expect(client).to receive(:auth).with(subject); subject.auth }
  end

  context '#path' do
    before do
      allow(endpoint.client).to receive(:base).and_return(endpoint)
      stub_const('Kucoin::Api::ENDPOINTS', { base: { foo: 'v1/foo' } })
    end
    it { expect(subject.path(:foo)).to eq 'v1/foo' }
    it { expect(subject.path(:bar)).to be_nil }
  end
end
