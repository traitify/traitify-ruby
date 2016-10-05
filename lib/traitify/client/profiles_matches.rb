module Traitify
  module ProfilesMatches
    class Client < Stack
      def root(args = nil)
        set_verb(:get)

        add_path("/matches/#{args}")

        self
      end

      def groups(uuid)
        add_path("/groups/#{uuid}")
        request
      end

      def profiles(uuid)
        add_path("/profiles/#{uuid}")
        request
      end
    end
  end
end
