# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateArticle, type: :request do

  it 'is successful create Article ?' do

    # Create Article
    do_graphql_request

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createArticle'].symbolize_keys).to include(
      title: '[Test] Article',
      body: '[Test] Body article'
    )
  end

  def variables
    {
      title: '[Test] Article',
      body: '[Test] Body article'
    }
  end

  def query
    <<-GRAPHQL
      mutation($title: String!, $body: String!) {
        createArticle(title: $title, body: $body) {
          title
          body
        }
      }
    GRAPHQL
  end
end

