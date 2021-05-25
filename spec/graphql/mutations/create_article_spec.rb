# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateArticle, type: :request do

  let(:input) do
    {
      title: '[Test] Article Test',
      body: 'Body Test'
    }
  end

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
    #post('/graphql', params: { query: querySignInUser, variables: { credentials: input_for_sign_in_user[:credentials] } }, as: :json)
    do_graphql_request
    # Create Article
    post('/graphql', params: { query: queryCreateArticle, variables: { title: input[:title], body: input[:body] } }, as: :json)

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createArticle'].symbolize_keys).to include(
      title: "[Test] Article Test",
      body: "Body Test"
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

  def queryCreateArticle
    <<-GRAPHQL
      mutation($title: String!, $body: String!) {
        createArticle(title: $title, body: $body) {
          title
          body
          user{
            name
          }
        }
      }
    GRAPHQL
  end
end

