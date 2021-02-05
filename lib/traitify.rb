require "traitify/configuration"
require "traitify/client"
require "traitify/data"
require "traitify/error"
require "traitify/response"
require "logger"
require "active_support"
require "active_support/core_ext/object/deep_dup"

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
        log.progname = name
      end
    end

    def log(level, message)
      message = "[traitify-ruby] #{message}"
      case level
      when :debug
        logger.debug message
      else
        logger.info message
      end
    end
  end
end
