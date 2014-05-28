module Traitify
  class PersonalityBlend
    attr_accessor :personality_type1, :personality_type2, :name, :description, :compliments, :conflicts, :compatible_work_environments_1, :compatible_work_environments_2, :compatible_work_environments_3, :compatible_work_environments_4

    def initialize(options = {})
      self.personality_type1              = options[:personality_type1]
      self.personality_type2              = options[:personality_type2]
      self.name                           = options[:name]
      self.description                    = options[:description]
      self.compliments                    = options[:compliments]
      self.compatible_work_environments_1 = options[:compatible_work_environments_1]
      self.compatible_work_environments_2 = options[:compatible_work_environments_2]
      self.compatible_work_environments_3 = options[:compatible_work_environments_3]
      self.compatible_work_environments_4 = options[:compatible_work_environments_4]
    end

    def self.parse_json(personality_blend)
      personality_type1 = PersonalityType.parse_json(personality_blend["personality_type1"])
      personality_type2 = PersonalityType.parse_json(personality_blend["personality_type2"])

      Result.new(
        personality_type1:                      personality_type1,
        personality_type2:                      personality_type2,
        name:                                   personality_blend["name"],
        description:                            personality_blend["description"],
        compliments:                            personality_blend["compliments"],
        conflicts:                              personality_blend["conflicts"],
        compatible_work_environments_1:         personality_blend["compatible_work_environments_1"],
        compatible_work_environments_2:         personality_blend["compatible_work_environments_2"],
        compatible_work_environments_3:         personality_blend["compatible_work_environments_3"],
        compatible_work_environments_4:         personality_blend["compatible_work_environments_4"]
      )
    end

    def to_hash
      {
        personality_type1:              personality_type1.to_hash,
        personality_type2:              personality_type2.to_hash,
        name:                           name,
        description:                    description,
        compliments:                    compliments,
        conflicts:                      conflicts,
        compatible_work_environments_1: compatible_work_environments_1,
        compatible_work_environments_2: compatible_work_environments_2,
        compatible_work_environments_3: compatible_work_environments_3,
        compatible_work_environments_4: compatible_work_environments_4
      }
    end
  end
end
