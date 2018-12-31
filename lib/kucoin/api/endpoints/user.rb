# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class User < Base
        def info
          auth.ku_request :get, :info
        end
      end
    end
  end
end
