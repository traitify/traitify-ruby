module Traitify
  module Matches
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        

        if args
          set_params(args)
        end

        add_path("/matches")
        
        self
      end

      def careers(*options)
        options = {} unless options.is_a?(Hash)
        
        if options[:number_of_matches]
          number_of_matches = options["number_of_matches"].delete
        else
          number_of_matches = 10
        end
        options[:number_of_matches] = number_of_matches
        set_params(options)
        add_path("/careers")
        self
      end
    end
  end
end