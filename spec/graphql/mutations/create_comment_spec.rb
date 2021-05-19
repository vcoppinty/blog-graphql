# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateArticle, type: :request do

  let(:input_for_sign_in_user) do
    {
      credentials: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  it 'is successful create Article ?' do

    # Error User must Exist if not sign in before
    # Login test User
    post('/graphql', params: { query: querySignInUser, variables: { credentials: input_for_sign_in_user[:credentials] } }, as: :json)

    # Create Comment
    article = Article.all.sample

    expect(article).not_to be_nil

    post(
      '/graphql',
      params: {
        query: queryCreateComment,
        variables: {
          body: 'This is a test',
          articleId: article.id,
          rating: 5
        }
      },
      as: :json
    )

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createComment'].symbolize_keys).to include(
      body: "This is a test",
      article: {
        "id" => article.id.to_s
      },
      user: {
        "email" => 'user@example.com'
      }
    )
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

  def queryCreateComment
    <<-GRAPHQL
      mutation($body: String!, $articleId: ID!, $rating: Int!) {
        createComment(body: $body, articleId: $articleId, rating: $rating) {
          body
          user{
            email
          }
          article{
            id
          }
        }
      }
    GRAPHQL
  end
end

