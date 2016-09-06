module Traitify
  module Analytics
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        add_path("/analytics")

        self
      end

      def decks(deck_id=nil)
        res = AnalyticsDecks::Client.new
        res.set_params(@params)
        res.add_path(@url)
        res.root(deck_id)
      end
    end
  end
end