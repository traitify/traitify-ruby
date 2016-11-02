require "traitify/configuration"
require "traitify/client"
require "traitify/error"
require 'logger'

module Traitify
  extend Configuration

  self.host = "http://api-sandbox.traitify.com"
  self.version = "v1"
  self.locale_key = "en-us"

  class << self
    attr_writer :logger

    def new(options = {})
      Traitify::Client.new(options)
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
      end
    end
  end
end
