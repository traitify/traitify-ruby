require 'uri'

module Traitify
  module Request
    def method_missing(meth, *args, &block)
      if [:get, :post, :put, :delete, :patch].include? meth
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
      
      prev = ""
      nex = ""
      if req.env.response_headers["link"]
        rels = req.env.response_headers["link"]
        if rels.include?("prev")
          prev_url = rels.split(",").first 
          prev = prev_url.gsub(/rel\=\"prev\"/, " ").gsub(/</, "").to_s.split(" ").to_a[0].to_s.gsub(/\>;/, "")
        end
        
        if rels.include?("next")
          next_url = rels.split(",").last
          nex = next_url.gsub(/rel\=\"next\"/, " ").gsub(/</, "").to_s.split(" ").to_a[0].to_s.gsub(/\>;/, "")
        end
      end
      data = {
        page: {},
        total: req.env.response_headers["x-total-count"],
        data: req.body
      }

      data[:page][:previous] = CGI::parse(URI(prev).query)["paging_cursor"].first unless prev.empty?
      data[:page][:next] = CGI::parse(URI(nex).query)["paging_cursor"].first unless nex.empty?

      data
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
