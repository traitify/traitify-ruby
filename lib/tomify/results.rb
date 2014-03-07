module Tomify
  class Result
    attr_accessor :overview, :personality_types

    def initialize(options = {})
      self.overview          = options[:overview]
      self.personality_types = options[:personality_types]
    end

    def self.parse_json(result)
      personality_types = result["personality_types"].collect { |p| PersonalityType.parse_json(p) }

      Result.new(
        overview:          result["overview"],
        personality_types: personality_types
      )
    end

    def to_hash
      {
        overview:          overview,
        personality_types: personality_types.collect { |p| p.to_hash }
      }
    end
  end
end
