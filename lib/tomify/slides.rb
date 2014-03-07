module Tomify
  class Slide
    attr_accessor :id, :image_url, :response, :order, :time_taken

    def initialize(options = {})
      self.id         = options[:id]
      self.image_url  = options[:image_url]
      self.response   = options[:response]
      self.order      = options[:order]
      self.time_taken = options[:time_taken]
    end

    def self.parse_json(slide)
      Slide.new(
        id:         slide["id"],
        image_url:  slide["image_url"],
        response:   slide["response"],
        order:      slide["order"],
        time_taken: slide["time_taken"]
      )
    end

    def to_hash
      {
        id: id,
        image_url: image_url,
        response: response,
        order: order,
        time_taken: time_taken
      }
    end
  end
end
