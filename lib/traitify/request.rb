module Traitify
  module Request
    def method_missing(meth, *args, &block)
      if [:get, :post, :put, :delete].include? meth
        request(meth, *args)
      else
        super
      end
    end

    def request(method, path, options = {})
      options[:locale_key] ||= locale_key || "en-us" unless options.is_a?(Array) || options.delete(:no_locale)
      path += path_with_params(path, options) if method == :get
      conn(url: host).send(method) do |request|
        request.body = options.to_json unless method == :get || options.empty?
        request.url [version, path].join
      end.body
    end

    def request_with_pages(method, path, options = {})
      options[:locale_key] ||= locale_key || "en-us" unless options.is_a?(Array) || options.delete(:no_locale)
      path += path_with_params(path, options) if method == :get
      req = conn(url: host).send(method) do |request|
        request.body = options.to_json unless method == :get || options.empty?
        request.url [version, path].join
      end
      {
        rels: req.rels,
        content: req.body
      }
    end

    private
    def path_with_params(path, options)
      params = ""
      return params if options.empty?
      params << (path.include?("?") ? "&" : "?")
      params << URI.encode_www_form(options)
      params
    end
  end
end
