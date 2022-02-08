# frozen_string_literal: true

module Mutations
  class DeleteComment < Mutations::BaseMutation

    class NotAuthorized < StandardError
      def message
        "User has not authorized to delete this comment."
      end
    end

    argument :id, ID, required: true

    field :comment, Types::ArticleType, null: true

    def resolve(id: nil)

      comment = Comment.find(id)
      article = comment.article

      raise NotAuthorized if comment.user != context[:current_user] || article.user != context[:current_user]

      comment.destroy!

      { comment: comment }
    end
  end
end
