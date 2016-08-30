module Traitify
  class Client
    module Profile
      def profiles(options = {})
        get("/profiles", options).collect do |profile|
          Hashie::Mash.new profile
        end
      end
      alias_method :find_profiles, :profiles

      def profile(profile_id, options = {})
        Hashie::Mash.new get("/profiles/#{profile_id}", options)
      end
      alias_method :find_profile, :profile

      def create_profile(options)
        Hashie::Mash.new post("/profiles", options)
      end
    end
  end
end
