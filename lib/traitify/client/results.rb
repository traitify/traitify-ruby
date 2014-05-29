module Traitify
  class Client
    module Result
      def find_results(assessment_id, image_pack = nil)
        if image_pack
          results_params = { image_pack: image_pack }
        elsif self.image_pack
          results_params = { image_pack: self.image_pack }
        else
          results_params = nil
        end

        response = get("/assessments/#{assessment_id}/personality_types", results_params)

        Traitify::Result.parse_json(response)
      end
    end
  end
end
