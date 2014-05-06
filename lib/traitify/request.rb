module Traitify
  module Request
    def get(path, options = {})
      request(:get, path, options)
    end

    def post(path, options = {})
      request(:post, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    def delete(path, options={})
      request(:delete, path, options)
    end

    def last_response
      @last_response
    end

    private
    def request(method, path, options = {})
      path = "#{self.api_version}#{path}"
      connection_options = {}.merge!(url: self.api_host)

      response = connection(connection_options).send(method) do |request|
        request.body = options.to_json if options
        case method
        when :get
          request.url(path)
        when :post
          request.url(path)
        when :put
          request.url(path)
        when :delete
          request.url(path)
        end
      end

      @last_response = response
      response.body
    end
  end
end
