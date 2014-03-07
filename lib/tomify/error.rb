module Tomify
  class Error < StandardError
    attr_accessor :response

    def self.from(response)
      status  = response.status

      if klass = case status
                 when 400 then Tomify::BadRequest
                 when 401 then Tomify::Unauthorized
                 when 404 then Tomify::NotFound
                 when 422 then Tomify::UnprocessableEntity
                 end

      klass.new(response)
      end
    end

    def initialize(response)
      @response = response
      super(error_message)
    end

    def errors
      response.body
    end

    private
    def error_message
      message =  "#{response.env[:method].upcase} "
      message << "#{response.env[:url].to_s} | "
      message << "#{response.status}: "
      message << "#{response.body.map{|k,v| "#{k}: #{v.first}"}.join(", ")}"
      message
    end
  end

  class BadRequest < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end
end
