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
      
      conn(url: host).send(method) do |request|
        if method == :get || options.empty?
          request.params = options
        else
          request.body = options.to_json
        end
        request.url [version, path].join
      end.body
    end

    def request_with_pages(method, path, options = {})
      options[:locale_key] ||= locale_key || "en-us" unless options.is_a?(Array) || options.delete(:no_locale)

      req = conn(url: host).send(method) do |request|
        if method == :get || options.empty?
          request.params = options
        else
          request.body = options.to_json
        end

        request.url [version, path].join
      end

      prev = ""
      nex = ""

      if req.env.response_headers["link"]
        rels = req.env.response_headers["link"]
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
        total: req.env.response_headers["x-total-count"],
        data: req.body
      }

      data[:page][:previous] = CGI::parse(URI(prev).query)["paging_cursor"].first unless prev.empty?
      data[:page][:next] = CGI::parse(URI(nex).query)["paging_cursor"].first unless nex.empty?

      data
    end
  end
end
