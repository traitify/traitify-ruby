module Traitify
  class Client
    module Deck
      def decks(image_pack = nil)
        image_pack ||= self.image_pack

        response = image_pack ?
          get("/decks?image_pack=#{image_pack}") :
          get("/decks")

        response.collect { |deck| Hashie::Mash.new(deck) }
      end
      alias_method :find_decks, :decks
    end
  end
end
