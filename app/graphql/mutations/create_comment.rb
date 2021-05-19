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

      article = Article.find(article_id)

      Comment.create!(
        body: body,
        article: article,
        user: context[:current_user],
        rating: rating
      )

      total = article.comments.inject(0){|sum, comment| sum + comment.rating } + rating
      article.rating = (total / (article.comments.count +1)).to_f.ceil

      article.save
    end
  end
end