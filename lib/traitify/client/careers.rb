module Traitify
  module Careers
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && !args.is_a?(Hash)
          add_path("/careers/#{args}")
        else
          add_path("/careers")
          if args
            set_params(args)
          end
        end

        self
      end
    end
  end
end