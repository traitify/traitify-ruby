module Traitify
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)
    attr_reader :type, :verb, :path, :params

    def initialize(options = {})
      Traitify.options.merge(options).each do |key, value|
        send("#{key}=", value) unless value.nil?
      end

      set(verb: :get, path: "", params: {})
    end

    def method_missing(method, *args, &block)
      base(method, *args)
    end

    Dir["./lib/traitify/client/*.rb"].each do |file|
      name = File.basename(file, ".rb").capitalize
      include Object.const_get("Traitify::#{name}")
    end
  end
end
