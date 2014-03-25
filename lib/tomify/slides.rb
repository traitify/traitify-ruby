module Tomify
  class Slide
    attr_accessor :id, :position, :caption, :image_desktop, :image_desktop_retina, :image_phone_landscape, :image_phone_portrait, :response, :time_taken, :completed_at, :created_at

    def initialize(options = {})
      self.id                    = options[:id]
      self.position              = options[:position]
      self.caption               = options[:caption]
      self.image_desktop         = options[:image_desktop]
      self.image_desktop_retina  = options[:image_desktop_retina]
      self.image_phone_landscape = options[:image_phone_landscape]
      self.image_phone_portrait  = options[:image_phone_portrait]
      self.response              = options[:response]
      self.time_taken            = options[:time_taken]
      self.completed_at          = options[:completed_at]
      self.created_at            = options[:created_at]
    end

    def self.parse_json(slide)
      created_at = slide["created_at"] ? Time.at(slide["created_at"]) : nil
      completed_at = slide["completed_at"] ? Time.at(slide["completed_at"]) : nil

      Slide.new(
        id:                    slide["id"],
        position:              slide["position"],
        caption:               slide["caption"],
        image_desktop:         slide["image_desktop"],
        image_desktop_retina:  slide["image_desktop_retina"],
        image_phone_landscape: slide["image_phone_landscape"],
        image_phone_portrait:  slide["image_phone_portrait"],
        response:              slide["response"],
        time_taken:            slide["time_taken"],
        completed_at:          completed_at,
        created_at:            created_at
      )
    end

    def to_hash
      {
        id:                    id,
        position:              position,
        caption:               caption,
        image_desktop:         image_desktop,
        image_desktop_retina:  image_desktop_retina,
        image_phone_landscape: image_phone_landscape,
        image_phone_portrait:  image_phone_portrait,
        response:              response,
        time_taken:            time_taken,
        completed_at:          completed_at,
        created_at:            created_at
      }
    end

    def to_update_params
      {
        id:                    id,
        response:              response,
        time_taken:            time_taken
      }
    end
  end

  class Slides
    attr_accessor :assessment_id, :all

    def initialize(options = {})
      self.assessment_id = options[:assessment_id]
      self.all           = options[:all]
    end

    def self.parse_json(assessment_id, slides)
      Slides.new(
        assessment_id: assessment_id,
        all:           slides.collect { |slide| Tomify::Slide.parse_json(slide) }
      )
    end

    def to_hash
      {
        assessment_id: assessment_id,
        all:           all.collect { |slide| slide.to_hash }
      }
    end

    def to_update_params
      all.collect { |slide| slide.to_update_params }
    end

    # Allows slides to forward Array methods to all
    def method_missing(method, *args)
      return all.send(method, *args) if all.respond_to?(method)
      super
    end
  end
end
