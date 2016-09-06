# require base modules
require "traitify/connection"
require "traitify/request"
require "hashie"
# require client modules in lib/Traitify/client
Dir[File.expand_path("../client/*.rb", __FILE__)].each {|f| require f }

module Traitify
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    alias_method :api_host, :host
    alias_method :api_host=, :host=

    alias_method :api_version, :version
    alias_method :api_version=, :version=

    alias_method :secret, :secret_key
    alias_method :secret=, :secret_key=

    def initialize(options = {})
      options = Traitify.options.merge(options)

      options.each do |key, value|
        send("#{key}=", value) unless value.nil?
      end
    end

    include Traitify::Connection
    include Traitify::Configuration
    include Traitify::Request
  end
end
