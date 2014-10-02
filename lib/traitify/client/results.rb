module Traitify
  class Client
    module Result
      def results(assessment_id, image_pack = nil)
        image_pack ||= self.image_pack

        response = image_pack ?
          get("/assessments/#{assessment_id}/personality_types?image_pack=#{image_pack}") :
          get("/assessments/#{assessment_id}/personality_types")

        Hashie::Mash.new(response)
      end
      alias_method :find_results, :results

      def assessment_personality_traits(assessment_id, personality_type_id = nil)
        response = personality_type_id ?
          get("/assessments/#{assessment_id}/personality_types/#{personality_type_id}/personality_traits") :
          get("/assessments/#{assessment_id}/personality_traits")

        response.collect { |personality_trait| Hashie::Mash.new(personality_trait) }
      end
      alias_method :find_assessment_personality_traits, :assessment_personality_traits

      def raw_personality_traits(assessment_id)
        get("/assessments/#{assessment_id}/personality_traits/raw").collect do |personality_trait|
          Hashie::Mash.new(personality_trait)
        end
      end
      alias_method :find_personality_traits, :raw_personality_traits

      def career_matches(assessment_id, number_of_matches=10)
        response = get("/assessments/#{assessment_id}/matches/careers?number_of_matches=#{number_of_matches}")
        response.collect { |career| Hashie::Mash.new(career) }
      end
    end
  end
end
