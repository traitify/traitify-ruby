require "tomify/version"
require "tomify/configuration"
require "tomify/client"

module Tomify
  extend Configuration

  class << self
    def new(options = {})
      Tomify::Client.new(options)
    end
  end
end
