module Traitify
  class Client
    module Assessment
      def create_assessment(options = {})
        options[:deck_id] ||= deck_id
        Hashie::Mash.new post("/assessments", options)
      end

      def assessment(assessment_id, options = {})
        Hashie::Mash.new get("/assessments/#{assessment_id}", options)
      end
      alias :find_assessment :assessment

      def assessment_with_results(assessment_id, image_pack = nil, data = [], options = {})
        image_pack ||= self.image_pack
        options[:image_pack] = image_pack if image_pack
        options[:data] = data.join(",")

        Hashie::Mash.new get("/assessments/#{assessment_id}", options)
      end
    end
  end
end
