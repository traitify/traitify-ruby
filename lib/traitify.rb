require "traitify/version"
require "traitify/configuration"
require "traitify/client"

module Traitify
  extend Configuration

  class << self
    def new(options = {})
      Traitify::Client.new(options)
    end
  end
end
