module Traitify
  module PersonalityTypes
    class Client < Stack
      def root(args = nil, params={})
        set_verb(:get)
        
        if args && (args.is_a?(String) || args.is_a?(Integer))
          id = args
          add_path("/personality_types/#{id}")
          set_params(params)
        else
          if args
            set_params(args)
          end

          add_path("/personality_types")
        end

        if !@params[:image_pack] && !@params["image_pack"] && Traitify.options[:image_pack]
          set_param(:image_pack, Traitify.options[:image_pack])
        end

        self
      end

      def personality_traits(options = {})
        res = Traitify::PersonalityTraits::Client.new(self.api)
        res.add_path(*@url)
        res.set_params(@params)
        res.root(options)
      end

      def with_results(*options)
        set_params({data: options.join(",")})
        self
      end
    end
  end
end