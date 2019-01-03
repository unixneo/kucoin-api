RSpec.describe Kucoin::Api::Middleware::AuthRequest do
  let(:api_key) { 'foo' }
  let(:api_secret) { 'bar' }
  let(:endpoint_url) { URI('http://example.com/endpoint') }
  let(:body) { '' }
  let(:env) do
    Faraday::Env.from({
      url: endpoint_url,
      body: body,
      request_headers: Faraday::Utils::Headers.new("KC-API-NONCE" => '981147906000')
    })
  end
  let(:middleware) { described_class.new(lambda{|env| env}, api_key, api_secret) }
  subject { middleware }

  describe 'process' do
    context 'without api key' do
      let(:api_key) { nil }
      it 'raise error' do
        expect { subject.call(env) }.to raise_error(Kucoin::Api::MissingApiKeyError, /API KEY not provided/)
      end
    end

    context 'without secret key' do
      let(:api_secret) { nil }
      it 'raise error' do
        expect { subject.call(env) }.to raise_error(Kucoin::Api::MissingApiSecretError, /API SECRET not provided/)
      end
    end
    context 'valid' do
      before { subject.call(env) }
      context 'with key and secret' do
        let(:api_key) { 'key_foo' }
        let(:api_secret) { 'secret_bar' }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'key_foo'
          expect(env[:request_headers]["KC-API-SIGNATURE"]).to eq 'cedd518160251a31e505f07034c7d8bf743f45576b4581bd881ccdeb8061f5e4'
          expect(env.url.query).to eq ''
        end
      end

      context 'with url query' do
        let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'foo'
          expect(env[:request_headers]["KC-API-SIGNATURE"]).to eq 'e5d4b2b43b6c3930a8dd3ad6d53ced4978dc957f61eec815807b3372d8802e92'
          expect(env.url.query).to eq 'cat=3&flower=6'
        end
      end

      context 'with body query' do
        let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
        let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'foo'
          expect(env[:request_headers]["KC-API-SIGNATURE"]).to eq '6fb701f2f6c5a15447ae4bb3330189dcdf5d20df1ca3d9f3ff6c78d9c9c99f5b'
          expect(env.url.query).to eq 'apple=1&ball=2&cat=6&dog=4&eye=5&flower=6'
        end
      end
    end

    describe '#str_for_sign' do
      let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
      let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
      it 'generate path for signature' do
        expect(subject.send(:str_for_sign, env)).to eq '/endpoint/981147906000/apple=1&ball=2&cat=6&dog=4&eye=5&flower=6'
      end
    end

    describe '#query_string' do
      let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
      let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
      it 'sort query and body params' do
        expect(subject.send(:query_string, env)).to eq 'apple=1&ball=2&cat=6&dog=4&eye=5&flower=6'
      end
    end
  end
end
