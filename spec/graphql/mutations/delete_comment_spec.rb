# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DeleteArticle, type: :request do

  it 'is successful delete comment ?' do

    user_comment = User.first.comments.first
    another_user_comment = Comment.where.not(user: User.first).first

    if user_comment
      do_graphql_request(qry: query, var: comment_id(user_comment.id) )
      comment = response.parsed_body.dig('data', 'deleteComment', 'comment')
      expect(Comment.find_by(id: comment['id'])).to be_nil
    end

    if another_user_comment
      expect {
        do_graphql_request(qry: query, var: comment_id(another_user_comment.id) )
      }.to raise_error(Mutations::DeleteComment::NotAuthorized)
    end
  end

  def comment_id(id)
    {
      id: id
    }
  end

  def query
    <<-GRAPHQL
      mutation($id: ID!) {
        deleteComment(id: $id) {
          comment {
            body
          }
        }
      }
    GRAPHQL
  end

end

