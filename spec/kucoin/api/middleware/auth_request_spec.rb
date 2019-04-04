RSpec.describe Kucoin::Api::Middleware::AuthRequest do
  let(:api_key) { 'foo' }
  let(:api_secret) { 'bar' }
  let(:api_passphrase) { 'passphrase' }
  let(:endpoint_url) { URI('http://example.com/endpoint') }
  let(:body) { '' }
  let(:env) do
    Faraday::Env.from({
      url: endpoint_url,
      body: body,
      method: 'post',
      request_headers: Faraday::Utils::Headers.new("KC-API-TIMESTAMP" => '1554196634670')
    })
  end
  let(:middleware) { described_class.new(lambda{|env| env}, api_key, api_secret, api_passphrase) }
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
    context 'without api passphrase' do
      let(:api_passphrase) { nil }
      it 'raise error' do
        expect { subject.call(env) }.to raise_error(Kucoin::Api::MissingApiPassphraseError, /API PASSPHRASE not provided/)
      end
    end
    context 'valid' do
      before { subject.call(env) }
      context 'with key and secret' do
        let(:api_key) { 'key_foo' }
        let(:api_secret) { 'secret_bar' }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'key_foo'
          expect(env[:request_headers]["KC-API-SIGN"]).to eq '5HXeVm4ZBjqRv+7L6xYWcsvKWzeLgZUxhtNcdlIVM/k='
          expect(env.url.query).to eq nil
        end
      end

      context 'with url query' do
        let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'foo'
          expect(env[:request_headers]["KC-API-SIGN"]).to eq 'E8Q387na3it/sKmp9pyi+RJ22DQ7gjPERraX+lqHDLU='
          expect(env.url.query).to eq 'flower=6&cat=3'
        end
      end

      context 'with body query' do
        let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
        let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
        it 'add Signature' do
          expect(env[:request_headers]["KC-API-KEY"]).to eq 'foo'
          expect(env[:request_headers]["KC-API-SIGN"]).to eq 'c5DSA7letF79uUerAxNJFUpp4Nk5MwtbFzRSm4b9q5w='
          expect(env.url.query).to eq 'flower=6&cat=3'
          expect(env.body).to eq '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}'
        end
      end
    end

    describe '#str_to_sign' do
      let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
      let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
      it 'generate path for signature' do
        expect(subject.send(:str_to_sign, env)).to eq '1554196634670POST/endpoint?flower=6&cat=3{"ball":2,"apple":1,"cat":6,"eye":5,"dog":4}'
      end
    end

    describe '#query_string' do
      let(:endpoint_url) { URI('http://example.com/endpoint?flower=6&cat=3') }
      let(:body) { '{"ball": 2, "apple": 1, "cat": 6, "eye": 5, "dog": 4}' }
      it 'sort query and body params' do
        expect(subject.send(:query_string, env)).to eq '{"ball":2,"apple":1,"cat":6,"eye":5,"dog":4}'
      end
    end
  end
end
