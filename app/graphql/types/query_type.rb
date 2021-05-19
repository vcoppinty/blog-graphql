# frozen_string_literal: true
module Types
  class QueryType < Types::BaseObject

    # User fields
    field :users, [Types::UserType], null: false, description: "Find all users"

    field :getUserById, UserType, null: true do
      description "Find user by id"
      argument :id, ID, required: true
    end

    field :getUserByEmail, UserType, null: true do
      description "Find user by id"
      argument :email, String, required: true
    end

    # Article fields
    field :articles, [Types::ArticleType], null: false, description: "Find All articles"
    field :myArticles, [Types::ArticleType], null: false, description: "Find my articles"

    # Article fields
    field :comments, [Types::CommentType], null: false, description: "Find All comments"
    field :myComments, [Types::CommentType], null: false, description: "Find my comments"


    # User method
    def users
      User.all
    end

    def getUserById(id: nil)
      User.find(id)
    end

    def getUserByEmail(email: nil)
      User.find_by(email: email)
    end

    # Article method
    def articles
      Article.all
    end

    def myArticles
      Article.where(user: context[:current_user])
    end

    # Comment method
    def comments
      Comment.all
    end

    def myComments
      Comment.where(user: context[:current_user])
    end
  end
end
