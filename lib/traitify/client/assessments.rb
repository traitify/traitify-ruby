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

      def assessment_with_results(assessment_id, image_pack = nil, data = [])
        image_pack ||= self.image_pack

        response = image_pack ?
          get("/assessments/#{assessment_id}?data=#{data.join(",")}&image_pack=#{image_pack}") :
          get("/assessments/#{assessment_id}?data=#{data.join(",")}")

        Hashie::Mash.new(response)
      end

      private
      def deck_id_from(options)
        options[:deck_id] || deck_id
      end
    end
  end
end
