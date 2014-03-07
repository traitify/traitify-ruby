module Tomify
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
    def endpoint
      "https://#{self.api_host}/#{self.api_version}"
    end

    def request(method, path, options = {})
      connection_options = {}.merge!(:url => endpoint)

      response = connection(connection_options).send(method) do |request|
        case method
        when :get
          request.url(path, options)
        when :post
          request.url(path, options)
        when :put
          request.url(path, options)
        when :delete
          request.url(path, options)
        end
      end

      @last_response = response
      response.body
    end
  end
end
