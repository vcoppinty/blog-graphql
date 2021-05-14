# frozen_string_literal: true

module Mutations
  class CreateArticle < Mutations::BaseMutation

    argument :title, String, required: true
    argument :body, String, required: true

    type Types::ArticleType

    def resolve(title: nil, body: nil)
      Article.create!(
        title: title,
        body: body,
        user: context[:current_user]
      )
   end
  end
end