require "faraday"
require "faraday/net_http"
require "faraday/retry"
require "traitify/middleware/formatter"
require "traitify/middleware/raise_error"

module Traitify
  class Client
    module Connection
      def connection(options = {})
        Faraday.new(options) do |faraday|
          faraday.request(:authorization, :basic, secret_key || public_key, "x")
          faraday.request(:json)
          faraday.request(:retry, retry_options) if auto_retry
          faraday.headers["Accept"] = "application/json"
          faraday.options.params_encoder = Faraday::FlatParamsEncoder
          faraday.response(:logger, Traitify.logger, formatter: Traitify::Middleware::Formatter)
          faraday.response(:raise_traitify_error)
          faraday.response(:json)
          faraday.adapter(:net_http)
        end
      end
    end
  end
end
