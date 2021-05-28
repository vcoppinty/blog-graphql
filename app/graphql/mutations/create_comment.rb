# frozen_string_literal: true

module Mutations
  class CreateComment < Mutations::BaseMutation

    argument :body, String, required: true
    argument :article_id, ID, required: true
    argument :rating, Integer, required: true

    type Types::CommentType

    def resolve(body: nil, article_id: nil, rating: nil)

      article = Article.find(article_id)

      comment = Comment.create!(
        body: body,
        article: article,
        user: context[:current_user],
        rating: rating
      )

      total = article.comments.inject(0){|sum, comment| sum + comment.rating } + rating
      article.rating = (total / (article.comments.count +1)).to_f.ceil

      article.save
      comment
    end
  end
end