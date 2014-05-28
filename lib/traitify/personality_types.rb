module Traitify
  class PersonalityType
    attr_accessor :id, :name, :description, :badge, :score

    def initialize(options = {})
      self.id          = options[:id]
      self.name        = options[:name]
      self.description = options[:description]
      self.badge       = options[:badge]
      self.score       = options[:score]
    end

    def self.parse_json(personality_type)
      if personality_type
        badge = Badge.parse_json(personality_type["badge"])

        PersonalityType.new(
          id:          personality_type["id"],
          name:        personality_type["name"],
          description: personality_type["description"],
          badge:       badge,
          score:       personality_type["score"]
        )
      else
        nil
      end
    end

    def to_hash
      {
        id:          id,
        name:        name,
        description: description,
        badge:       badge.to_hash,
        score:       score
      }
    end
  end
end
