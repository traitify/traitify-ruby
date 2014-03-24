module Tomify
  class Assessment
    attr_accessor :id, :deck_id, :user_id, :created_at, :completed_at

    def initialize(options = {})
      self.id            = options[:id]
      self.deck_id       = options[:deck_id]
      self.user_id       = options[:user_id]
      self.created_at    = options[:created_at]
      self.completed_at  = options[:completed_at]
    end

    def self.parse_json(assessment)
      created_at = assessment["created_at"] ? Time.at(assessment["created_at"]) : nil
      completed_at = assessment["completed_at"] ? Time.at(assessment["completed_at"]) : nil

      Assessment.new(
        id:           assessment["id"],
        deck_id:      assessment["deck_id"],
        user_id:      assessment["user_id"],
        created_at:   created_at,
        completed_at: completed_at
      )
    end

    def to_hash
      {
        id:           id,
        deck_id:      deck_id,
        user_id:      user_id,
        created_at:   created_at,
        completed_at: completed_at
      }
    end
  end
end
