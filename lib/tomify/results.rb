module Tomify
  class Result
    attr_accessor :personality_blend, :personality_types

    def initialize(options = {})
      self.personality_blend = options[:personality_blend]
      self.personality_types = options[:personality_types]
    end

    def self.parse_json(result)
      personality_blend = PersonalityBlend.parse_json(result["personality_blend"])
      personality_types = result["personality_types"].collect { |p| PersonalityType.parse_json(p.personality_type.merge!(score: p.score)) }

      Result.new(
        personality_blend: personality_blend,
        personality_types: personality_types
      )
    end

    def to_hash
      {
        personality_blend: personality_blend.to_hash,
        personality_types: personality_types.collect { |p| p.to_hash }
      }
    end
  end
end
