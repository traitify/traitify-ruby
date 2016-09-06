def require_folder(folder)
  Dir["./#{folder}/*.rb"].each {|file| require file }
end


require "traitify/version"
require "traitify/configuration"
require "traitify/stack"
require "traitify/client"

module Traitify
  extend Configuration

  #Defaults
  self.api_host = "http://api-sandbox.traitify.com"
  self.version = "v1"

  #Add Root Api Node
  extend Root
  

  def self.root
    Stack.new
  end


  class << self
    def new(options = {})
      Traitify::Client.new(options)
    end
  end
end
