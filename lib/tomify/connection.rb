require "faraday_middleware"
require "tomify/error"

module Tomify
  module Connection
    def connection(options = {})
      connection ||= Faraday.new(options) do |faraday|
        faraday.request :url_encoded
        faraday.request :basic_auth, self.secret, "x"
        faraday.use ContentTypeMiddleware
        faraday.use ErrorMiddleware
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end

      connection
    end

    private
    class ContentTypeMiddleware < Faraday::Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        env[:request_headers]["Accept"] = "application/json"
        env[:request_headers]["Content-Type"] = "application/json"
        @app.call(env)
      end
    end

    class ErrorMiddleware < Faraday::Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @app.call(env).on_complete do |e|
          if error = Tomify::Error.from(e[:response])
            raise error
          end
        end
      end
    end
  end
end
