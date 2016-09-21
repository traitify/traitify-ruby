module Traitify
  module AnalyticsDecksAssessments
    class Client < Stack
      def root(args = nil)
        set_verb(:get)

        add_path("/assessments")

        self
      end
    end
    def groups(params)
      add_params({group_ids: params})

      self
    end
  end
end
