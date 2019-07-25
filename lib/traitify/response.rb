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
          if prev_link = links.find{ |link| link.include?("rel=\"prev\"") }
            prev_link = prev_link.split(/>|</)[1]
            page[:previous] = {
              url: prev_link,
              params: CGI.parse(prev_link.split("?")[1..-1].join("?"))
            }
          end

          if next_link = links.find{ |link| link.include?("rel=\"next\"") }
            next_link = next_link.split(/>|</)[1]
            page[:next] = {
              url: next_link,
              params: CGI.parse(next_link.split("?")[1..-1].join("?"))
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
