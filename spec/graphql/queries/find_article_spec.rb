# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do

  it 'is successful login ?' do

    # Get Article
    do_graphql_request

    data = response.parsed_body['data']

    expect(data).to be_successful_query

    expect(data['allArticles'].first.symbolize_keys).to include(
                                                          {
                                                            title: "title test by user1",
                                                            body: "body test by user1",
                                                            user: {
                                                              "id" => "1"
                                                            }
                                                          }
                                                        )

    expect(data['allArticles'].last.symbolize_keys).to include(
                                                          {
                                                            title: "title test by user2",
                                                            body: "body test by user2",
                                                            user: {
                                                              "id" => "2"
                                                            }
                                                          }
                                                        )
  end

  def variables
    {
      filter: {
        bodyContains: "user1",
        OR: {
          titleContains: "user2"
        }
      }
    }
  end

  def query
    <<-GRAPHQL
      query{
        allArticles{
          body
          title
          user {
            id
          }
        }
      }
    GRAPHQL
  end
end

