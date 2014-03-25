module Tomify
  class Badge
    attr_accessor :image_small, :image_medium, :image_large

    def initialize(options = {})
      self.image_small  = options[:image_small]
      self.image_medium = options[:image_medium]
      self.image_large  = options[:image_large]
    end

    def self.parse_json(badge)
      Badge.new(
        image_small:  badge["image_small"],
        image_medium: badge["image_medium"],
        image_large:  badge["image_large"]
      )
    end

    def to_hash
      {
        image_small:  image_small,
        image_medium: image_medium,
        image_large:  image_large
      }
    end
  end
end
