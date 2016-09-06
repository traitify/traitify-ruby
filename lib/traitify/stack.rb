#Because You Can Stack Commands ;)
module Traitify
  class Stack
    attr_reader :data

    def method_missing(method, *args, &block)
      if !self.respond_to?(method)
        a = self.request
        if a.respond_to?(method)
          a.send(method)
        else
          self
        end
      end
    end

    def initialize
      @verb = "get"
      @data = []
      @url = []
      @options = {}
      @params = nil
    end

    def run(method, args, block)
      self.send(method, *args, &block)
    end

    def add_path(*values)
      values.each do |value|
        @url.push(value)
      end
      self
    end

    def set_verb(verb)
      @verb = verb
      self
    end

    def set_params(params)
      @params = params
      self
    end

    def add_params(params)
      @params ||= {}
      @params = @params.merge(params)
      self
    end

    def set_param(key, value)
      @params[key] = value
      self
    end

    def find(params)
      set_verb(:get)
      add_params(params)
      request
    end

    def request
      url = @url.join("")

      if @params
        data = Traitify.new.send(@verb, url, @params)
      else
        data = Traitify.new.send(@verb, url)
      end
      if data.class.name == "Array"
        data.collect do |row|
          Hashie::Mash.new(row)
        end
      else
        Hashie::Mash.new(data)
      end
    end
  end
end