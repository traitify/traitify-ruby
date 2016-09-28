module Traitify
  module AnalyticsDecksAssessments
    class Client < Stack
      def root(args = nil)
        set_verb(:get)

        add_path("/assessments")

        self
      end
      def groups(params)
        add_params({group_ids: params})

        self
      end
      def profiles(params)
        add_params({profile_ids: params})

        self
      end
    end
  end
end
