module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, description: "ID of user"
    field :name, String, null: false, description: "Name of user"
    field :email, String, null: false, description: "Email of user"
    field :articles, [ArticleType], null: true, description: "Articles of user"
    field :comments, [CommentType], null: true, description: "Comments of user"
  end
end
