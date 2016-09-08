module Traitify
  module AnalyticsDecks
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args
          add_path("/decks/#{args}")
        else
          add_path("/decks")
        end

        self
      end

      def assessments(params=nil)
        res = AnalyticsDecksAssessments::Client.new(self.api)
        res.set_params(@params)
        res.add_path(@url)
        res.root(params)
      end

      def personality_traits(params=nil)
        res = AnalyticsDecksPersonalityTraits::Client.new(self.api)
        res.set_params(@params)
        res.add_path(@url)
        res.root(params)
      end


      def personality_types(params=nil)
        res = AnalyticsDecksPersonalityTypes::Client.new(self.api)
        res.set_params(@params)
        res.add_path(@url)
        res.root(params)
      end
    end
  end
end