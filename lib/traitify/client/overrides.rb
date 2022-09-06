module Traitify
  class Client
    module Overrides
      def perform_overrides
        send("#{type}_override") if respond_to? "#{type}_override"

        self
      end

      def assessments_override
        if params[:data] && params[:data].is_a?(Array)
          @params[:data] = params[:data].join(",")
        end
      end

      def personality_types_override
        if image_pack && params[:image_pack].nil?
          @params[:image_pack] = image_pack
        end
      end

      def locales_override
        @params.delete(:locale_key)
      end
    end
  end
end
