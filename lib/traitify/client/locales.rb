module Traitify
  module Locales
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && !args.is_a?(Hash)
          add_path("/locales/#{args}")
        else
          add_path("/locales")
          if args
            set_params(args)
          end
        end

        set_params({no_locale: true})

        self
      end
    end
  end
end