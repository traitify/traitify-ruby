module Traitify
  module AnalyticsDecksPersonalityTypes
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        add_path("/personality_types")

        self
      end
    end
  end
end