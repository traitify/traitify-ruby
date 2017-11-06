module Traitify
  class Response
    attr_reader :request

    def initialize(request)
      @request = request
    end

    def data
      @data ||= Traitify::Data.new @request.body
    end

    def page
      @page ||= begin
        page = {}

        if request.env.response_headers["link"]
          links = request.env.response_headers["link"].split(",")
          if prevLink = links.find { |link| link.include?("rel=\"prev\"") }
            prevLink = prevLink.split(/>|</)[1]
            page[:previous] = {
              url: prevLink,
              params: CGI::parse(prevLink.split("?")[1..-1].join("?"))
            }
          end

          if nextLink = links.find { |link| link.include?("rel=\"next\"") }
            nextLink = nextLink.split(/>|</)[1]
            page[:next] = {
              url: nextLink,
              params: CGI::parse(nextLink.split("?")[1..-1].join("?"))
            }
          end
        end

        Traitify::Data.new page
      end
    end

    def total
      @total ||= @request.env.response_headers["x-total-count"]
    end
  end
end
