module Traitify
  module PersonalityTraits
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && args.first
          id = args.first
          add_path("/personality_traits/#{id}")
        else
          add_path("/personality_traits")
        end
        
        self
      end
    end
  end
end