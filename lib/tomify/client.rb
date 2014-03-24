# require base modules
require "tomify/connection"
require "tomify/request"
require "tomify/assessments"
require "tomify/personality_types"
require "tomify/results"
require "tomify/slides"
require "tomify/users"
# require client modules in lib/tomify/client
Dir[File.expand_path("../client/*.rb", __FILE__)].each {|f| require f }

module Tomify
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options = {})
      options = Tomify.options.merge(options)

      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Tomify::Connection
    include Tomify::Configuration
    include Tomify::Request

    include Tomify::Client::Assessment
    include Tomify::Client::User
    include Tomify::Client::Result
    include Tomify::Client::Slide
  end
end
