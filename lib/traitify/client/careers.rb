module Traitify
  class Client
    module Career
      # Valid options are
      # - page
      # - careers_per_page
      # - experience_levels
      def careers(options = {})
        response = options.empty? ?
          get("/careers") :
          get("/careers?" + options.collect{ |k,v| "#{k}=#{v}" }.join("&"))

        response.collect { |career| Hashie::Mash.new(career) }
      end
      alias_method :find_careers, :careers

      def career(id)
        response = get("/careers/#{id}")

        Hashie::Mash.new(response)
      end
      alias_method :find_career, :career
    end
  end
end
