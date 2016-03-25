module Traitify
  class Client
    module Major
      # Valid options are
      # - page
      # - majors_per_page
      # - experience_levels
      def majors(options = {})
        get("/majors", options).collect { |major| Hashie::Mash.new(major) }
      end
      alias_method :find_majors, :majors

      def major(id, options = {})
        Hashie::Mash.new get("/majors/#{id}", options)
      end
      alias_method :find_major, :major
    end
  end
end
