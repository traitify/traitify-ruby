module Traitify
  class Client
    module Request
      [:get, :post, :put, :delete, :patch].each do |method|
        define_method method do |path, params = {}|
          copy.set(verb: method, path: path, params: params).request
        end
      end

      def request
        @data = objectify base_request.body
      end
      alias_method :fetch, :request

      def paginate
        @data = objectify base_request_with_pages
      end

      def data
        @data ||= request
      end

      private
      def objectify(data)
        case data
        when Array then data.collect { |row| objectify row }
        when Hash then
          OpenStruct.new data.transform_values { |value| objectify value }
        else data
        end
      end

      def base_request
        unless params.is_a?(Array) || params[:locale_key] || locale_key.nil?
          set_param(:locale_key, locale_key)
        end

        Traitify.log :info, "#{verb.to_s.upcase}: #{host}/#{version}#{path}"
        Traitify.log :debug, "AUTH: #{self.secret_key || self.public_key}"

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

      def base_request_with_pages
        request = base_request

        data = {
          page: {},
          total: request.env.response_headers["x-total-count"],
          data: request.body
        }

        if request.env.response_headers["link"]
          links = request.env.response_headers["link"].split(",")
          if prevLink = links.find { |link| link.include?("rel=\"prev\"") }
            prevLink = prevLink.split(/>|</)[1]
            data[:page][:previous] = {
              url: prevLink,
              params: CGI::parse(prevLink.split("?")[1..-1].join("?"))
            }
          end

          if nextLink = links.find { |link| link.include?("rel=\"next\"") }
            nextLink = nextLink.split(/>|</)[1]
            data[:page][:next] = {
              url: nextLink,
              params: CGI::parse(nextLink.split("?")[1..-1].join("?"))
            }
          end
        end

        data
      end
    end
  end
end
