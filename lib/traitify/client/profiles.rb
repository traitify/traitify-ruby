module Traitify
  module Profiles
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && !args.is_a?(Hash)
          add_path("/profiles/#{args}")
        else
          set_params(args) if args
          add_path("/profiles")
        end
        
        self
      end

      def create(options)
        set_verb(:post)

        set_params(options)
        request
      end

      def destroy
        set_verb(:delete)
        
        request
      end
    end
  end
end