# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateArticle, type: :request do

  let(:article) do
    Article.all.sample
  end

  it 'is successful create Comment ?' do

    # Create Comment
    expect(article).not_to be_nil

    do_graphql_request

    expect(response.parsed_body).to be_successful_query

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['createComment'].symbolize_keys).to include(
      body: "This is a test",
      article: {
        "id" => article.id.to_s
      },
      user: {
        "email" => 'test@test.com'
      }
    )
  end

  def variables
    {
      body: 'This is a test',
      articleId: article.id.to_i,
      rating: 5
    }
  end

  def query
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