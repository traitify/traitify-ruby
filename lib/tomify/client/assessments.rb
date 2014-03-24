module Tomify
  class Client
    module Assessment
      def create_assessment(options = {})
        assessment_params = { deck_id: self.deck_id }
        assessment_params.merge!(deck_id: options[:deck_id]) if options[:deck_id]
        assessment_params.merge!(user_id: options[:user_id]) if options[:user_id]
        response = post("/assessments", assessment_params)

        Tomify::Assessment.parse_json(response)
      end

      def find_assessment(assessment_id)
        response = get("/assessments/#{assessment_id}")

        Tomify::Assessment.parse_json(response)
      end
    end
  end
end
