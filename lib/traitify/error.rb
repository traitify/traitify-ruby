module Traitify
  class Error < StandardError
    attr_accessor :response

    def self.from(response)
      klass = case response.status
      when 400 then Traitify::BadRequest
      when 401 then Traitify::Unauthorized
      when 404 then Traitify::NotFound
      when 422 then Traitify::UnprocessableEntity
      when 500..505 then Traitify::ServerError
      end

      klass.new(response) if klass
    end

    def initialize(response)
      @response = response

      super(error_message)
    end

    private

    def error_message
      message =  "#{response.request.http_method.upcase} | "
      message << "#{response.request.url} | "
      message << "#{response.status} | "

      error = response.body
      error = error.first if error.is_a?(Array)
      error = error.message if error.respond_to?(:message)

      message << error.to_s if error.present?
      message
    end
  end

  class BadRequest < Error; end
  class Unauthorized < Error; end
  class NotFound < Error; end
  class UnprocessableEntity < Error; end
  class ServerError < Error; end
end
