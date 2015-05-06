require "faraday_middleware"
require "traitify/error"
require "pry"

module Traitify
  module Connection
    def conn(options = {})
      Faraday.new(options) do |faraday|
        faraday.request :url_encoded
        faraday.request :basic_auth, self.secret_key, "x"
        faraday.headers["Accept"] = "application/json"
        faraday.headers["Content-Type"] = "application/json"
        faraday.use ErrorMiddleware
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    private
    class ErrorMiddleware < Faraday::Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env).on_complete do |e|
          if error = Traitify::Error.from(e)
            raise error
          end
        end
      end
    end
  end
end
