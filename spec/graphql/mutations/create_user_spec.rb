# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :request do

  let(:input) do
    {
      name: 'userTest',
      auth_provider: {
        credentials: {
          email: 'user@example.com',
          password: 'password'
        }
      }
    }
  end

  it 'is successful ?' do

    user_test = User.find_by(email: "user@example.com")
    user_test.delete unless user_test.nil?

    post('/graphql', params: { query: query, variables: { name: input[:name], authProvider: input[:auth_provider] } }, as: :json)

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createUser'].symbolize_keys).to include(
      name: 'userTest'
    )

  end

  def query
    <<-GRAPHQL
      mutation($name: String!, $authProvider: AuthProviderSignupData!) {
        createUser(name: $name, authProvider: $authProvider) {
          id
          name
        }
      }
    GRAPHQL
  end
end

