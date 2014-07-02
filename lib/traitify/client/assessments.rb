module Traitify

  class Client
    module Assessment
      def create_assessment(options = {})
        Hashie::Mash.new post("/assessments", { deck_id: deck_id_from(options) })
      end

      def assessment(assessment_id)
        Hashie::Mash.new get("/assessments/#{assessment_id}")
      end
      alias :find_assessment :assessment

      private

      def deck_id_from(options)
        options[:deck_id] || deck_id
      end

    end
  end
end
