module Traitify
  class Client
    module Request
      [:get, :post, :put, :delete, :patch].each do |method|
        define_method method do |path, params = {}|
          copy.set(verb: method, path: path, params: params).request
        end
      end

      def request
        @data = hashify base_request.body
      end
      alias_method :fetch, :request

      def paginate
        @data = hashify base_request_with_pages
      end

      def data
        @data ||= request
      end

      private
      def hashify(data)
        return Hashie::Mash.new(data) unless data.is_a? Array

        data.collect { |row| Hashie::Mash.new(row) }
      end

      def base_request
        unless params.is_a?(Array) || params[:locale_key] || locale_key.nil?
          set_param(:locale_key, locale_key)
        end

        Traitify.logger.info "#{verb.to_s.upcase}: #{host}/#{version}#{path}"
        Traitify.logger.debug "Authentication: #{self.secret_key}"

        connection(url: host).send(verb) do |request|
          unless params.empty?
            if verb == :get
              request.params = params
              Traitify.logger.info "PARAMS: #{request.params}"
            else
              request.body = params.to_json
              Traitify.logger.info "BODY: #{request.body}"
            end
          end
          request.url [version, path].join
        end
      end

      def base_request_with_pages
        request = base_request
        nex = prev = ""

        if request.env.response_headers["link"]
          rels = request.env.response_headers["link"]
          url = rels.split(",")
          if url.select { |a| a.include?('rel="prev"') }[0]
            prev_url = url.select { |a| a.include?('rel="prev"') }[0]
            prev = prev_url.gsub(/rel\=\"prev\"/, " ").gsub(/</, "").to_s.split(" ").to_a[0].to_s.gsub(/\>;/, "")
          end

          if url.select { |a| a.include?('rel="next"') }[0]
            next_url = url.select { |a| a.include?('rel="next"') }[0]
            nex = next_url.gsub(/rel\=\"next\"/, " ").gsub(/</, "").to_s.split(" ").to_a[0].to_s.gsub(/\>;/, "")
          end
        end

        data = {
          page: {},
          total: request.env.response_headers["x-total-count"],
          data: request.body
        }

        data[:page][:previous] = CGI::parse(URI(prev).query)["paging_cursor"].first unless prev.empty?
        data[:page][:next] = CGI::parse(URI(nex).query)["paging_cursor"].first unless nex.empty?

        data
      end
    end
  end
end
