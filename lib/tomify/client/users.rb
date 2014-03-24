module Tomify
  class Client
    module User
      def create_user(user_params)
        response = post("/users", user: user_params)

        Tomify::User.parse_json(response)
      end

      def find_user(user_id)
        response = get("/users/#{user_id}")

        Tomify::User.parse_json(response)
      end
    end
  end
end
