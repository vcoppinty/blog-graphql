# frozen_string_literal: true

module Mutations
  class DeleteArticle < Mutations::BaseMutation

    class NotAuthorized < StandardError
      def message
        "User has not authorized to delete this article."
      end
    end

    argument :id, ID, required: true

    field :article, Types::ArticleType, null: true

    def resolve(id: nil)

      article = Article.find(id)

      raise NotAuthorized if article.user != context[:current_user]

      article.destroy!

      { article: article }
    end
  end
end
