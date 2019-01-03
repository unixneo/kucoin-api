RSpec.describe Kucoin::Api::REST do
  let(:client) { described_class.new }
  subject { client }

  it { expect(described_class::BASE_URL).to eq 'https://api.kucoin.com' }
  it { expect(described_class::API_KEY).to eq '' }
  it { expect(described_class::API_SECRET).to eq '' }

  [
    ['account',   Kucoin::Api::Endpoints::Account],
    ['currency',  Kucoin::Api::Endpoints::Currency],
    ['language',  Kucoin::Api::Endpoints::Language],
    ['market',    Kucoin::Api::Endpoints::Market],
    ['order',     Kucoin::Api::Endpoints::Order],
    ['user',      Kucoin::Api::Endpoints::User],
  ].each do |endpoint_name, endpoint_class|
    describe "##{endpoint_name}" do
      it do
        expect(subject.send(endpoint_name)).to be_a endpoint_class
        expect(subject.send(endpoint_name).client).to eq subject
      end
    end
  end

  describe '#open' do
    let(:endpoint) { subject.account }
    it do
      expect(Kucoin::Api::REST::Connection).to receive(:new).with(endpoint, url: Kucoin::Api::REST::BASE_URL).and_call_original
      connection = subject.open(endpoint)
      expect(connection.client.builder.handlers).to include(FaradayMiddleware::EncodeJson, FaradayMiddleware::ParseJson)
    end
  end

  describe '#auth' do
    let(:client) { described_class.new(api_key: 'foo', api_secret: 'bar') }
    let(:endpoint) { subject.account }
    it do
      expect(Kucoin::Api::REST::Connection).to receive(:new).with(endpoint, url: Kucoin::Api::REST::BASE_URL).and_call_original
      connection = subject.auth(endpoint)
      expect(connection.client.builder.handlers).to include(FaradayMiddleware::EncodeJson, FaradayMiddleware::ParseJson, Kucoin::Api::Middleware::NonceRequest, Kucoin::Api::Middleware::AuthRequest)
    end
  end
end
