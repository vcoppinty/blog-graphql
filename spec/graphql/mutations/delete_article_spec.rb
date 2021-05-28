# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DeleteArticle, type: :request do

  let(:input_for_sign_in_user) do
    {
      credentials: {
        email: 'user@example.com',
        password: 'password'
      }
    }
  end

  it 'is successful delete article ?' do

    user_article = User.first.articles.first
    another_user_article = Article.where.not(user: User.first).first

    if user_article
      do_graphql_request(qry: query, var: { id: user_article.id } )
      article = response.parsed_body.dig('data', 'deleteArticle', 'article')
      expect(Article.find_by(id: article['id'])).to be_nil
    end

    if another_user_article
      expect {
        do_graphql_request(qry: query, var: { id: another_user_article.id } )
      }.to raise_error(Mutations::DeleteArticle::NotAuthorized)
    end
  end

  def query
    <<-GRAPHQL
        mutation($id: ID!) {
          deleteArticle(id: $id) {
            article {
              title
            }
          }
      }
    GRAPHQL
  end

end

