module Types
  class QueryType < Types::BaseObject

    field :users, [Types::UserType], null: false, description: "Find all users"

    field :getUserById, UserType, null: true do
      description "Find user by id"
      argument :id, ID, required: true
    end

    field :getUserByEmail, UserType, null: true do
      description "Find user by id"
      argument :email, String, required: true
    end

    def users
      User.all
    end

    def getUserById(id: nil)
      User.find(id)
    end

    def getUserByEmail(email: nil)
      User.find_by(email: email)
    end
  end
end
