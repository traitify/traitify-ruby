module Tomify
  class Client
    module Slide
      def find_slides(assessment_id)
        response = get("/assessments/#{assessment_id}/slides")

        Tomify::Slides.parse_json(assessment_id, response)
      end

      def update_slides(slides)
        response = put("/assessments/#{slides.assessment_id}/slides", slides: slides.to_hash)

        Tomify::Slides.parse_json(slides.assessment_id, response)
      end

      def update_slide(hash_or_assessment_id, slide = nil)
        if slide
          assessment_id = hash_or_assessment_id
          slide_id = slide.id
          hash = {
            response:   slide.response,
            time_taken: slide.time_taken
          }
        else
          assessment_id = hash_or_assessment_id[:assessment_id]
          slide_id =      hash_or_assessment_id[:slide_id]
          hash = {
            response:   hash_or_assessment_id[:response],
            time_taken: hash_or_assessment_id[:time_taken]
          }
        end

        response = put("/assessments/#{assessment_id}/slides/#{slide_id}", hash)

        Tomify::Slide.parse_json(response)
      end
    end
  end
end
