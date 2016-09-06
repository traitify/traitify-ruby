module Traitify
  module Assessments
    class Client < Stack
      def root(args = nil)
        set_verb(:get)
        
        if args && !args.is_a?(Hash)
          add_path("/assessments/#{args}")
        else
          add_path("/assessments")
        end

        self
      end

      def create(options = {})
        set_verb(:post)
        if !options.first && Traitify.deck_id
          options[:deck_id] = Traitify.deck_id
        end
        set_params(options)
        request
      end

      def personality_types(options = {})
        res = Traitify::PersonalityTypes::Client.new
        res.add_path(*@url)
        res.root(options)
      end

      def personality_traits(options = {})
        res = Traitify::PersonalityTraits::Client.new
        res.add_path(*@url)
        res.root(options)
      end

      def matches(options = {})
        res = Traitify::Matches::Client.new
        res.add_path(*@url)
        res.root(options)
      end


      def slides(params = {})
        res = Slides::Client.new
        res.add_path(*@url)
        res.root(params)
      end

      def with_results(options = {})
        options[:data] = (options[:data] || options["data"]).join(",")
        set_params(options)
        request
      end
    end
  end
end