# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DeleteArticle, type: :request do

  let(:input_for_sign_in_user) do
    {
      credentials: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  it 'is successful delete comment ?' do
    # Login test User
    post('/graphql', params: { query: querySignInUser, variables: { credentials: input_for_sign_in_user[:credentials] } }, as: :json)

    user = response.parsed_body.dig('data', 'signInUser', 'user').symbolize_keys

    user_comment = User.find_by(email: user[:email]).comments.first
    another_user_comment = Comment.where.not(user: User.find_by(email: user[:email])).first

    if user_comment
      post('/graphql', params: { query: queryDeleteComment, variables: { id: user_comment.id } }, as: :json)
      comment = response.parsed_body.dig('data', 'deleteComment', 'comment')
      expect(Comment.find_by(id: comment['id'])).to be_nil
    end

    if another_user_comment
      expect {
        post('/graphql', params: { query: queryDeleteComment, variables: { id: another_user_comment.id } }, as: :json)
      }.to raise_error(Mutations::DeleteComment::NotAuthorized)
    end
  end

  def queryDeleteComment
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

  def querySignInUser
    <<-GRAPHQL
      mutation($credentials: AuthProviderCredentialsInput!) {
        signInUser(credentials: $credentials) {
          user {
            email
            name
          }
        }
      }
    GRAPHQL
  end

end

