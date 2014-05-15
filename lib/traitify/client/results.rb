module Traitify
  class Client
    module Result
      def find_results(assessment_id)
        response = get("/assessments/#{assessment_id}/personality_types")

        Traitify::Result.parse_json(response)
      end
    end
  end
end
