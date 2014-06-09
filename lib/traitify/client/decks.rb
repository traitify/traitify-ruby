module Traitify
  class Client
    module Deck
      def decks
        response = get("/decks")

        response.collect { |deck| Hashie::Mash.new(deck) }
      end
    end
  end
end
