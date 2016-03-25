module Traitify
  class Client
    module Deck
      def decks(image_pack = nil, options = {})
        image_pack ||= self.image_pack
        options[:image_pack] = image_pack if image_pack

        get("/decks", options).collect { |deck| Hashie::Mash.new(deck) }
      end
      alias_method :find_decks, :decks
    end
  end
end
