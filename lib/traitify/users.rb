module Traitify
  class User
    attr_accessor :id, :first_name, :last_name, :email, :created_at, :updated_at

    def initialize(options = {})
      self.id         = options[:id]
      self.first_name = options[:first_name]
      self.last_name  = options[:last_name]
      self.email      = options[:email]
      self.created_at = options[:created_at]
      self.updated_at = options[:updated_at]
    end

    def self.parse_json(user)
      created_at = user["created_at"] ? Time.at(user["created_at"]) : nil
      updated_at = user["updated_at"] ? Time.at(user["updated_at"]) : nil

      User.new(
        id:         user["id"],
        first_name: user["first_name"],
        last_name:  user["last_name"],
        email:      user["email"],
        created_at: created_at,
        updated_at: updated_at
      )
    end

    def to_hash
      {
        id:         id,
        first_name: first_name,
        last_name:  last_name,
        email:      email,
        created_at: created_at,
        updated_at: updated_at,
      }
    end
  end
end
