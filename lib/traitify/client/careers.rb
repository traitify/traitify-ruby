module Traitify
  class Client
    module Career
      # Valid options are
      # - page
      # - careers_per_page
      # - experience_levels
      def careers(options = {})
        get("/careers", options).collect { |career| Hashie::Mash.new(career) }
      end
      alias_method :find_careers, :careers

      def career(id, options = {})
        Hashie::Mash.new get("/careers/#{id}", options)
      end
      alias_method :find_career, :career
    end
  end
end
