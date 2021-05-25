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

    #do_graphql_request

    #post('/graphql', params: { query: query, variables: { name: input[:name], authProvider: input[:auth_provider] } }, as: :json)

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createUser'].symbolize_keys).to include(
      name: 'spec_test'
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

  def variables
    {
      name: 'spec_test',
      auth_provider: {
        credentials: {
          email: 'spec_test@test.com',
          password: '123'
        }
      }
    }
  end
end

