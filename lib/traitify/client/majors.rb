module Traitify
  class Client
    module Major
      # Valid options are
      # - page
      # - majors_per_page
      # - experience_levels
      def majors(options = {})
        response = options.empty? ?
          get("/majors") :
          get("/majors?" + options.collect{ |k,v| "#{k}=#{v}" }.join("&"))

        response.collect { |major| Hashie::Mash.new(major) }
      end
      alias_method :find_majors, :majors

      def major(id)
        response = get("/majors/#{id}")

        Hashie::Mash.new(response)
      end
      alias_method :find_major, :major
    end
  end
end
