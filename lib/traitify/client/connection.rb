require "faraday"
require "faraday/net_http"
require "traitify/middleware/formatter"
require "traitify/middleware/raise_error"

module Traitify
  class Client
    module Connection
      def connection(options = {})
        Faraday.new(options) do |faraday|
          faraday.request :authorization, :basic, secret_key || public_key, "x"
          faraday.request :json
          faraday.headers["Accept"] = "application/json"
          faraday.response :logger, Traitify.logger, formatter: Traitify::Middleware::Formatter
          faraday.response :raise_traitify_error
          faraday.response :json
          faraday.adapter :net_http
        end
      end
    end
  end
end
