RSpec.shared_context "endpoint", :shared_context => :metadata do
  let(:client) { Kucoin::Api::REST.new(api_key: 'foo', api_secret: 'bar') }
  let(:endpoint) { described_class.new(client) }
  subject { endpoint }

  let(:endpoint_url)    { 'v1/base/all' }
  let(:request_method)  { :get }
  let(:request_url)     { 'http://example.com' }
  let(:request_body)    { '' }
  let(:response_status) { 200 }
  let(:response_body)   { {success: true, data: { foo: :bar }} }

  before do
    stub_request(request_method, request_url)
      .with(body: request_body)
      .to_return(status: response_status, body: response_body.to_json)
  end
end

RSpec.configure do |rspec|
  rspec.include_context "endpoint", type: :endpoint
end
