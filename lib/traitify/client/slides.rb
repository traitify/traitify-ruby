module Traitify
  class Client
    module Slide
      def find_slides(assessment_id)
        response = get("/assessments/#{assessment_id}/slides")

        Traitify::Slides.parse_json(assessment_id, response)
      end

      def update_slides(slides)
        response = put("/assessments/#{slides.assessment_id}/slides", slides.to_update_params)

        Traitify::Slides.parse_json(slides.assessment_id, response)
      end

      def update_slide(hash_or_assessment_id, slide = nil)
        if slide
          assessment_id = hash_or_assessment_id
          slide_id = slide.id
          hash = slide.to_update_params.tap { |s| s.delete(:id) }
        else
          assessment_id = hash_or_assessment_id[:assessment_id]
          slide_id =      hash_or_assessment_id[:slide_id]
          hash = {
            response:   hash_or_assessment_id[:response],
            time_taken: hash_or_assessment_id[:time_taken]
          }
        end

        response = put("/assessments/#{assessment_id}/slides/#{slide_id}", hash)

        Traitify::Slide.parse_json(response)
      end
    end
  end
end
