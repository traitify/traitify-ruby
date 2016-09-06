module Traitify
  module Majors
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && !args.is_a?(Hash)
          add_path("/majors/#{args}")
        else
          add_path("/majors")
          if args
            set_params(args)
          end
        end

        self
      end
    end
  end
end