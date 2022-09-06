module Traitify
  class Client
    module Model
      def find(params = {})
        copy.set(verb: :get).add_params(params).request
      end
      alias_method :all, :find

      def create(params = {})
        copy.set(verb: :post, params: params).request
      end

      def destroy
        copy.set(verb: :delete).request
      end

      def update(params, verb = :put)
        copy.set(verb: verb, params: params).request
      end

      def base(name, params = {})
        client = copy.set(type: name, verb: :get).add_path("/#{name}")

        if [NilClass, Hash, Array].include? params.class
          client.set(params: params)
        else
          client.add_path("/#{params}")
        end

        client
      end

      private

      def copy
        Traitify.new(options).set(
          type: type.deep_dup,
          verb: verb.deep_dup,
          path: path.deep_dup,
          params: params.deep_dup
        )
      end
    end
  end
end
