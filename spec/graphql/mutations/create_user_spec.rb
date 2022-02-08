# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :request do

  it 'is successful ?' do

    do_graphql_request

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createUser'].symbolize_keys).to include(
      name: 'spec_test'
    )

    expect{do_graphql_request}.to raise_error(ActiveRecord::RecordInvalid)
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
      authProvider: {
        credentials: {
          email: 'spec_test@test.com',
          password: '123'
        }
      }
    }
  end
end

