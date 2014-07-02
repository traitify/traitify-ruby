module Traitify
  class Client
    module Deck
      def decks
        get("/decks").collect { |deck| Hashie::Mash.new(deck) }
      end
      alias_method :find_decks, :decks
    end
  end
end
