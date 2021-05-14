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

  it 'is successful delete article ?' do
    # Login test User
    post('/graphql', params: { query: querySignInUser, variables: { credentials: input_for_sign_in_user[:credentials] } }, as: :json)

    user = response.parsed_body.dig('data', 'signInUser', 'user').symbolize_keys

    user_article = User.find_by(email: user[:email]).articles.first
    another_user_article = Article.where.not(user: User.find_by(email: user[:email])).first

    if user_article
      post('/graphql', params: { query: queryDeleteArticle, variables: { id: user_article.id } }, as: :json)
      article = response.parsed_body.dig('data', 'deleteArticle', 'article')
      expect(Article.find_by(id: article['id'])).to be_nil
    end

    if another_user_article
      expect {
        post('/graphql', params: { query: queryDeleteArticle, variables: { id: another_user_article.id } }, as: :json)
      }.to raise_error(Mutations::DeleteArticle::NotAuthorized)
    end
  end

  def queryDeleteArticle
    <<-GRAPHQL
        mutation($id: ID!) {
          deleteArticle(id: $id) {
            article {
              title
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

