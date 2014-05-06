module Traitify
  class PersonalityBlend
    attr_accessor :personality_type1, :personality_type2, :name, :description, :compliments, :conflicts

    def initialize(options = {})
      self.personality_type1 = options[:personality_type1]
      self.personality_type2 = options[:personality_type2]
      self.name              = options[:name]
      self.description       = options[:description]
      self.compliments       = options[:compliments]
      self.conflicts         = options[:conflicts]
    end

    def self.parse_json(personality_blend)
      personality_type1 = PersonalityType.parse_json(personality_blend["personality_type1"])
      personality_type2 = PersonalityType.parse_json(personality_blend["personality_type2"])

      Result.new(
        personality_type1: personality_type1,
        personality_type2: personality_type2,
        name:              personality_blend["name"],
        description:       personality_blend["description"],
        compliments:       personality_blend["compliments"],
        conflicts:         personality_blend["conflicts"]
      )
    end

    def to_hash
      {
        personality_type1: personality_type1.to_hash,
        personality_type2: personality_type2.to_hash,
        name:              name,
        description:       description,
        compliments:       compliments,
        conflicts:         conflicts
      }
    end
  end
end
