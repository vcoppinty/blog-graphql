# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do

  let(:input_for_sign_in_user) do
    {
      credentials: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  it 'is successful login ?' do
    # Login test User
    post('/graphql', params: { query: querySignInUser, variables: { credentials: input_for_sign_in_user[:credentials] } }, as: :json)

    # Get Article
    post('/graphql', params: { query: queryMyArticles, variables: {} }, as: :json)

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['myArticles'].first.symbolize_keys).to include(
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

  def queryMyArticles
    <<-GRAPHQL
        {
          myArticles{
            title
            body
            user {
              id
            }
          }
        }
    GRAPHQL
  end
end

