module Traitify
  class Client
    module Result
      def find_results(assessment_id, image_pack = nil)
        image_pack ||= self.image_pack

        if image_pack
          response = get("/assessments/#{assessment_id}/personality_types?image_pack=#{image_pack}")
        else
          response = get("/assessments/#{assessment_id}/personality_types")
        end

        Traitify::Result.parse_json(response)
      end
    end
  end
end
