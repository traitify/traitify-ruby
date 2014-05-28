module Traitify
  class Badge
    attr_accessor :image_small, :image_medium, :image_large, :font_color, :color_1, :color_2, :color_3

    def initialize(options = {})
      self.image_small  = options[:image_small]
      self.image_medium = options[:image_medium]
      self.image_large  = options[:image_large]
      self.font_color   = options[:font_color]
      self.color_1      = options[:color1]
      self.color_2      = options[:color2]
      self.color_3      = options[:color3]
    end

    def self.parse_json(badge)
      if badge
        Badge.new(
          image_small:  badge["image_small"],
          image_medium: badge["image_medium"],
          image_large:  badge["image_large"],
          font_color:   badge["font_color"],
          color_1:      badge["color_1"],
          color_2:      badge["color_2"],
          color_3:      badge["color_3"]
        )
      else
        nil
      end
    end

    def to_hash
      {
        image_small:  image_small,
        image_medium: image_medium,
        image_large:  image_large,
        font_color:   font_color,
        color_1:      color1,
        color_2:      color2,
        color_3:      color3
      }
    end
  end
end
