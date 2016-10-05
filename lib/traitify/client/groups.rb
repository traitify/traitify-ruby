module Traitify
  module Groups
    class Client < Stack
      def root(args = nil)
        set_verb(:get)

        if args && !args.is_a?(Hash)
          add_path("/groups/#{args}")
        else
          add_path("/groups")
          if args
            set_params(args)
          end
        end


        self
      end

      def create(options)
        set_verb(:post)

        set_params(options)
        request
      end

      def matches
        res = GroupsMatches::Client.new(self.api)
        res.set_params(@params)
        res.add_path(@url)
        res.root
      end

      def update(options)
        set_verb(:patch)

        set_params(options)
        request
      end
    end
  end
end
