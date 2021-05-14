# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignInUser, type: :request do
  let(:input) do
    {
      credentials: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  it 'is successful ?' do

    post('/graphql', params: { query: query, variables: { credentials: input[:credentials] } }, as: :json)

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data.dig('signInUser', 'user').symbolize_keys).to include(
      name: 'userTest'
    )

  end

  def query
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

