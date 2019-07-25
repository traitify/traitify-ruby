module Traitify
  class Client
    module Request
      [:get, :post, :put, :delete, :patch].each do |method|
        define_method method do |path, params = {}|
          copy.set(verb: method, path: path, params: params).request
        end
      end

      def request
        @request = Traitify::Response.new base_request
      end
      alias_method :fetch, :request

      def data
        @data ||= request.data
      end

      private

      def base_request
        unless params.is_a?(Array) || params[:locale_key] || locale_key.nil?
          set_param(:locale_key, locale_key)
        end

        Traitify.log :info, "#{verb.to_s.upcase}: #{host}/#{version}#{path}"
        Traitify.log :debug, "AUTH: #{secret_key || public_key}"

        connection(url: host).send(verb) do |request|
          unless params.empty?
            if verb == :get
              request.params = params
              Traitify.log :info, "PARAMS: #{request.params}"
            else
              request.body = params.to_json
              Traitify.log :info, "BODY: #{request.body}"
            end
          end
          request.url [version, path].join
        end
      end
    end
  end
end
