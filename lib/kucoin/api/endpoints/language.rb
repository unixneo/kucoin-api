# frozen_string_literal: true
module Kucoin
  module Api
    module Endpoints
      class Language < Base
        def all options: {}
          open.ku_request :get, :all, options
        end

        def update lang
          auth.ku_request :post, :update, lang: lang
        end
      end
    end
  end
end
