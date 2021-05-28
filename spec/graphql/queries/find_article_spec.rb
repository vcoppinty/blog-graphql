# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do

  it 'is successful login ?' do

    # Get Article
    do_graphql_request

    data = response.parsed_body['data']
    expect(data).to be_successful_query

    expect(data['myArticles'].first.symbolize_keys).to include(
                                                      title: "title test by user1",
                                                      body: "body test by user1",
                                                      user: {
                                                        "id" => "1"
                                                      }
                                                    )
  end

  def query
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

