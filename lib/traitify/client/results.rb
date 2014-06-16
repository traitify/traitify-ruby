module Traitify
  class Client
    module Result
      def results(assessment_id, image_pack = nil)
        image_pack ||= self.image_pack

        if image_pack
          response = get("/assessments/#{assessment_id}/personality_types?image_pack=#{image_pack}")
        else
          response = get("/assessments/#{assessment_id}/personality_types")
        end

        Hashie::Mash.new(response)
      end
      alias_method :find_results, :results

      def assessment_personality_traits(assessment_id, personality_type_id = nil)
        if personality_type_id
          response = get("/assessments/#{assessment_id}/personality_types/#{personality_type_id}/personality_traits")
        else
          response = get("/assessments/#{assessment_id}/personality_traits")
        end

        response.collect { |personality_trait| Hashie::Mash.new(personality_trait) }
      end
      alias_method :find_assessment_personality_traits, :assessment_personality_traits
    end
  end
end
