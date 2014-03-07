module Tomify
  class PersonalityType
    attr_accessor :name, :description

    def initialize(options = {})
      self.name        = options[:name]
      self.description = options[:description]
    end

    def self.parse_json(personality_type)
      PersonalityType.new(
        name:        personality_type["name"],
        description: personality_type["description"]
      )
    end

    def to_hash
      {
        name:        name,
        description: description
      }
    end
  end
end
