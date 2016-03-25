module Traitify
  class Client
    module Slide
      def url_for_slides_by(assessment_id)
        "/assessments/#{assessment_id}/slides"
      end

      def find_slides(assessment_id, options = {})
        url = url_for_slides_by(assessment_id)
        get(url, options).collect { |slide| Hashie::Mash.new(slide) }
      end

      def update_slides(assessment_id, slides)
        url = url_for_slides_by(assessment_id)
        put(url, slides).collect { |slide| Hashie::Mash.new(slide) }
      end

      def update_slide(assessment_id, slide, options = {})
        slide_id = slide[:id] || slide.id
        options[:no_locale] = true
        options.merge(
          response: slide[:response] || slide.response,
          time_taken: slide[:time_taken] || slide.time_taken,
        )

        url = [url_for_slides_by(assessment_id), "/", slide_id].join
        Hashie::Mash.new put(url, options)
      end
    end
  end
end
