module Tomify
  class Client
    module Result
      def find_results(assessment_id)
        response = get("/assessments/#{assessment_id}/results")

        Tomify::Result.parse_json(response)
      end
    end
  end
end
