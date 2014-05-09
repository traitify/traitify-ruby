# require base modules
require "traitify/connection"
require "traitify/request"
require "traitify/assessments"
require "traitify/badges"
require "traitify/personality_blends"
require "traitify/personality_types"
require "traitify/slides"
require "traitify/users"
# require client modules in lib/Traitify/client
Dir[File.expand_path("../client/*.rb", __FILE__)].each {|f| require f }

module Traitify
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options = {})
      options = Traitify.options.merge(options)

      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Traitify::Connection
    include Traitify::Configuration
    include Traitify::Request

    include Traitify::Client::Assessment
    include Traitify::Client::User
    include Traitify::Client::Slide
  end
end
