module Traitify
  module Slides
    class Client < Stack
      def root(args = nil)
        set_verb(:get)

        if args && !args.is_a?(Hash)
          add_path("/slides/#{args}")
        else
          add_path("/slides")
        end

        self
      end

      def update(params = {})
        set_params(params)
        set_verb(:put)

        request
      end
    end
  end
end