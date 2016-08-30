module Traitify
  class Client
    module Analytics
      def assessment_analytics(deck_id, options = {})
        get("/analytics/decks/#{deck_id}/assessments", options).collect do |analytic|
          Hashie::Mash.new analytic
        end
      end

      def trait_analytics(deck_id, options = {})
        get("/analytics/decks/#{deck_id}/personality_traits", options).collect do |analytic|
          Hashie::Mash.new analytic
        end
      end

      def type_analytics(deck_id, options = {})
        get("/analytics/decks/#{deck_id}/personality_types", options).collect do |analytic|
          Hashie::Mash.new analytic
        end
      end
    end
  end
end
