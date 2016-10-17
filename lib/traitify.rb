require "traitify/configuration"
require "traitify/client"
require "traitify/error"

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
