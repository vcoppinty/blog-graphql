# frozen_string_literal: true

module Mutations
  class CreateComment < Mutations::BaseMutation

    argument :body, String, required: true
    argument :article_id, ID, required: true
    argument :rating, Integer, required: true

    type Types::CommentType

    field :body, String, null: false
    field :article, Types::ArticleType, null: false
    field :user, Types::UserType, null: false

    def resolve(body: nil, article_id: nil, rating: nil)
      Comment.create!(
        body: body,
        article: Article.find(article_id),
        user: context[:current_user],
        rating: rating
      )
    end
  end
end