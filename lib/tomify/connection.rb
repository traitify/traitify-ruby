require "faraday_middleware"
require "tomify/error"

module Tomify
  module Connection
    def connection(options = {})
      connection ||= Faraday.new(options) do |faraday|
        faraday.request :url_encoded
        faraday.use ErrorMiddleware
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end

      connection
    end

    private
    class ErrorMiddleware < Faraday::Middleware
      def initialize(app)
        @app = app
      end

      def call(e)
        @app.call(e).on_complete do |env|
          if error = Tomify::Error.from(env[:response])
            raise error
          end
        end
      end
    end
  end
end
