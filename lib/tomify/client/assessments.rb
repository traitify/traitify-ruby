module Tomify
  class Client
    module Assessment
      def create_assessment(user_id = nil)
        if user_id
          response = put("/assessments", user_id: user_id)
        else
          response = put("/assessments")
        end

        Tomify::Assessment.parse_json(response)
      end

      def find_assessment(assessment_id)
        response = get("/assessments/#{assessment_id}")

        Tomify::Assessment.parse_json(response)
      end

      def update_slides(assessment)
        slides_array = assessment.slides.collect{ |slide| slide.to_hash }
        response = put("/assessments/#{assessment.id}/slides", slides: slides_array)

        Tomify::Assessment.parse_json(response)
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
