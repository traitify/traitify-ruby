module Tomify
  class PersonalityType
    attr_accessor :name, :description, :badge, :score

    def initialize(options = {})
      self.name        = options[:name]
      self.description = options[:description]
      self.badge       = options[:badge]
      self.score       = options[:score]
    end

    def self.parse_json(personality_type)
      badge = Badge.parse_json(personality_type["badge"])

      PersonalityType.new(
        name:        personality_type["name"],
        description: personality_type["description"],
        badge:       badge,
        score:       personality_type["score"]
      )
    end

    def to_hash
      {
        name:        name,
        description: description,
        badge:       badge.to_hash,
        score:       score
      }
    end
  end
end
