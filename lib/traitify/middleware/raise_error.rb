# NOTE: Traitified version of Faraday error response middleware
# https://github.com/lostisland/faraday/blob/b3b922949d14f604ed11dc0f749455fc062777e7/lib/faraday/response/raise_error.rb
module Traitify
  module Middleware
    class RaiseError < Faraday::Middleware
      def on_complete(env)
        error = Traitify::Error.from(error_data(env))

        raise error if error
      end

      private

      def error_data(env)
        Traitify::Data.new(
          body: env.body,
          headers: env.response_headers,
          request: {
            body: env.request_body,
            headers: env.request_headers,
            http_method: env[:method],
            query: query_params(env),
            url: env.url,
            url_path: env.url.path
          },
          status: env.status
        )
      end

      def query_params(env)
        env.request.params_encoder ||= Faraday::Utils.default_params_encoder
        env.params_encoder.decode(env.url.query)
      end
    end
  end
end

Faraday::Response.register_middleware(raise_traitify_error: Traitify::Middleware::RaiseError)
