module Traitify
  class Client
    module Slide
      def url_for_slides_by(assessment_id)
        "/assessments/#{assessment_id}/slides"
      end

      def find_slides(assessment_id)
        url = url_for_slides_by(assessment_id)
        get(url).collect do |slide|
          Hashie::Mash.new(slide)
        end
      end

      def update_slides(assessment_id, slides)
        url = url_for_slides_by(assessment_id)
        put(url, slides).collect do |slide|
          Hashie::Mash.new(slide)
        end
      end

      def update_slide(assessment_id, slide)
        slide_id = slide[:id] || slide.id
        params = {
          response: slide[:response] || slide.response,
          time_taken: slide[:time_taken] || slide.time_taken,
        }

        url = [url_for_slides_by(assessment_id), "/", slide_id].join
        Hashie::Mash.new put(url, params)
      end
    end
  end
end
