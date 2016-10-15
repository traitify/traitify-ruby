require "faraday_middleware"
require "hashie"
require "uri"
require "pry"
Dir["./lib/traitify/**/*.rb"].each { |file| require file }

module Traitify
  extend Configuration

  self.host = "http://api-sandbox.traitify.com"
  self.version = "v1"
  self.locale_key = "en-us"

  class << self
    def new(options = {})
      Traitify::Client.new(options)
    end
  end
end
