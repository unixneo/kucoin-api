# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Base
        attr_reader :client
        def initialize client
          @client = client
        end

        def open
          client.open(self)
        end

        def auth
          client.auth(self)
        end

        def path(subpath)
          Kucoin::Api::ENDPOINTS[self.class.name.downcase.split('::').last.to_sym][subpath]
        end
      end
    end
  end
end
