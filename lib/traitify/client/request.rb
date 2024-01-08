module Traitify
  class Client
    module Request
      [:get, :post, :put, :delete, :patch].each do |verb|
        define_method verb do |path, params = {}|
          copy.set(verb: verb, path: path, params: params).request
        end
      end

      def data
        @data ||= request.data
      end

      def request
        @request = Traitify::Response.new(base_request)
      end
      alias_method :fetch, :request

      def retriable(**options)
        copy.tap do |client|
          client.auto_retry = true
          client.retry_options = options unless options.blank?
        end
      end

      private

      def base_request
        unless locale_key.nil? || params.is_a?(Array) || params[:locale_key]
          set_param(:locale_key, locale_key)
        end

        request_path = [version, path].join
        request_params = params&.as_json

        connection(url: host).public_send(verb, request_path, request_params)
      end
    end
  end
end
