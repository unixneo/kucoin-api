module Kucoin
  module Api
    class Error < StandardError; end
    class MissingApiKeyError < StandardError; end
    class MissingApiSecretError < StandardError; end
    class MissingApiPassphraseError < StandardError; end
    class ClientError < StandardError; end
  end
end
