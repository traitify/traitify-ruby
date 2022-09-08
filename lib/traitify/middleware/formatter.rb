module Traitify
  module Middleware
    class Formatter
      extend Forwardable

      attr_accessor :logger, :options

      def initialize(logger:, options:)
        @logger = logger
        @options = {log_level: :info, prefix: "[traitify-ruby]"}.merge(options)
      end

      def_delegators :@logger, :debug, :info, :warn, :error, :fatal

      def request(env)
        log(env[:method].upcase, env.url.to_s)
        log("AUTH", env.request_headers["Authorization"], level: :debug)
        log("BODY", env.body)
        log("PARAMS", query_params(env))
      end

      def response(env)
        log("STATUS", env.status)
      end

      private

      def log(name, object, level: nil)
        return unless object

        log = proc {
          "#{name}: #{object.respond_to?(:to_str) ? object.to_str : object.pretty_inspect&.strip}"
        }

        public_send(level || log_level, options[:prefix], &log)
      end

      def log_level
        unless [:debug, :info, :warn, :error, :fatal].include?(options[:log_level])
          return :info
        end

        options[:log_level]
      end

      def query_params(env)
        env.request.params_encoder ||= Faraday::Utils.default_params_encoder
        env.params_encoder.decode(env.url.query)
      end
    end
  end
end
