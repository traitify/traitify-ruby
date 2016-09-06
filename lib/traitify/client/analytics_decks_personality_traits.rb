module Traitify
  module AnalyticsDecksPersonalityTraits
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        add_path("/personality_traits")

        self
      end
    end
  end
end