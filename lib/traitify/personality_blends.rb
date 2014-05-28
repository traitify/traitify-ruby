module Traitify
  class PersonalityBlend
    attr_accessor :personality_type_1, :personality_type_2, :name, :description, :compliments, :conflicts, :compatible_work_environment_1, :compatible_work_environment_2, :compatible_work_environment_3, :compatible_work_environment_4

    def initialize(options = {})
      self.personality_type_1             = options[:personality_type_1]
      self.personality_type_2             = options[:personality_type_2]
      self.name                           = options[:name]
      self.description                    = options[:description]
      self.compliments                    = options[:compliments]
      self.conflicts                      = options[:conflicts]
      self.compatible_work_environment_1 = options[:compatible_work_environment_1]
      self.compatible_work_environment_2 = options[:compatible_work_environment_2]
      self.compatible_work_environment_3 = options[:compatible_work_environment_3]
      self.compatible_work_environment_4 = options[:compatible_work_environment_4]
    end

    def self.parse_json(personality_blend)
      if personality_blend
        personality_type_1 = PersonalityType.parse_json(personality_blend["personality_type_1"])
        personality_type_2 = PersonalityType.parse_json(personality_blend["personality_type_2"])

      PersonalityBlend.new(
        personality_type_1:                     personality_type_1,
        personality_type_2:                     personality_type_2,
        name:                                   personality_blend["name"],
        description:                            personality_blend["description"],
        compliments:                            personality_blend["compliments"],
        conflicts:                              personality_blend["conflicts"],
        compatible_work_environment_1:         personality_blend["compatible_work_environment_1"],
        compatible_work_environment_2:         personality_blend["compatible_work_environment_2"],
        compatible_work_environment_3:         personality_blend["compatible_work_environment_3"],
        compatible_work_environment_4:         personality_blend["compatible_work_environment_4"]
      )
      else
        nil
      end
    end

    def to_hash
      {
        personality_type_1:             personality_type_1.to_hash,
        personality_type_2:             personality_type_2.to_hash,
        name:                           name,
        description:                    description,
        compliments:                    compliments,
        conflicts:                      conflicts,
        compatible_work_environment_1: compatible_work_environment_1,
        compatible_work_environment_2: compatible_work_environment_2,
        compatible_work_environment_3: compatible_work_environment_3,
        compatible_work_environment_4: compatible_work_environment_4
      }
    end
  end
end
