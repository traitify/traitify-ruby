module Traitify
  module Setup
    def set(options)
      @type = options[:type] if options[:type]
      @verb = options[:verb] if options[:verb]
      @path = options[:path] if options[:path]
      @params = options[:params] if options[:params]
      perform_overrides
    end

    def set_verb(verb)
      set(verb: verb)
    end

    def set_path(path)
      set(path: path)
    end

    def set_params(new_params)
      set(params: new_params)
    end

    def set_param(key, value)
      set(params: params.merge(key => value))
    end

    def add_params(new_params)
      set(params: params.merge(new_params))
    end

    def add_path(value)
      set(path: path + value)
    end
  end
end
