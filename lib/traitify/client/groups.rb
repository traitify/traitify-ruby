module Traitify
  class Client
    module Group
      def groups(options = {})
        get("/groups", options).collect do |group|
          Hashie::Mash.new group
        end
      end
      alias_method :find_groups, :groups

      def group(group_id, options = {})
        Hashie::Mash.new get("/groups/#{group_id}", options)
      end
      alias_method :find_group, :group

      def create_group(options)
        Hashie::Mash.new post("/groups", options)
      end

      def remove_group(group_id, options = {})
        Hashie::Mash.new delete("/groups/#{group_id}", options)
      end

      def update_group(group_id, options = {})
        Hashie::Mash.new put("/groups/#{group_id}", options)
      end
    end
  end
end
