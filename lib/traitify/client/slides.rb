module Traitify
  class Client
    module Slide
      def find_slides(assessment_id)
        response = get("/assessments/#{assessment_id}/slides")

        response.collect { |slide| Hashie::Mash.new(slide) }
      end

      def update_slides(assessment_id, slides)
        response = put("/assessments/#{assessment_id}/slides", slides)

        response.collect { |slide| Hashie::Mash.new(slide) }
      end

      def update_slide(slide)
        params = { response: slide[:response], time_taken: slide[:time_taken] }

        response = put("/assessments/#{slide[:assessment_id]}/slides/#{slide[:slide_id]}", params)

        Hashie::Mash.new(response)
      end
    end
  end
end
