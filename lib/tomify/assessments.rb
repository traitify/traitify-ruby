module Tomify
  class Assessment
    attr_accessor :id, :user_id, :slides, :created_at, :updated_at

    def initialize(options = {})
      self.id          = options[:id]
      self.user_id     = options[:user_id]
      self.slides      = options[:slides]
      self.created_at  = options[:created_at]
      self.updated_at  = options[:updated_at]
    end

    def self.parse_json(assessment)
      slides = assessment["slides"].collect { |s| Slide.parse_json(s) }

      Assessment.new(
        id:         assessment["id"],
        user_id:    assessment["user_id"],
        slides:     slides,
        created_at: assessment["created_at"],
        updated_at: assessment["updated_at"]
      )
    end

    def to_hash
      {
        id:         id,
        user_id:    user_id,
        slides:     slides.collect { |s| s.to_hash },
        created_at: created_at,
        updated_at: updated_at
      }
    end
  end
end
