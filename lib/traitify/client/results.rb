module Traitify
  class Client
    module Result
      def results(assessment_id, image_pack = nil, options = {})
        image_pack ||= self.image_pack
        options[:image_pack] = image_pack if image_pack

        Hashie::Mash.new get("/assessments/#{assessment_id}/personality_types", options)
      end
      alias_method :find_results, :results

      def assessment_personality_traits(assessment_id, personality_type_id = nil, options = {})
        response = personality_type_id ?
          get("/assessments/#{assessment_id}/personality_types/#{personality_type_id}/personality_traits", options) :
          get("/assessments/#{assessment_id}/personality_traits", options)

        response.collect { |personality_trait| Hashie::Mash.new(personality_trait) }
      end
      alias_method :find_assessment_personality_traits, :assessment_personality_traits

      def raw_personality_traits(assessment_id, options = {})
        get("/assessments/#{assessment_id}/personality_traits/raw", options).collect do |personality_trait|
          Hashie::Mash.new(personality_trait)
        end
      end
      alias_method :find_personality_traits, :raw_personality_traits

      def career_matches(assessment_id, number_of_matches=10, options = {})
        response = get("/assessments/#{assessment_id}/matches/careers?number_of_matches=#{number_of_matches}", options)
        response.collect { |career| Hashie::Mash.new(career) }
      end
    end
  end
end
