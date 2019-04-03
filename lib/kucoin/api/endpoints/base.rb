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

        def path path
          path = path.to_s.split('/')
          action, subpath = path.first.to_sym, path[1..-1]
          path_array = (self.class.name.downcase.split('::')[3..-1] + subpath).map(&:to_sym)
          path_array.reduce(Kucoin::Api::ENDPOINTS) { |m, k| m.fetch(k, {}) }[action]
        end
      end
    end
  end
end
