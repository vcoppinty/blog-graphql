# frozen_string_literal: true

require 'search_object'
require 'search_object/plugin/graphql'

class Resolvers::ArticlesSearch < GraphQL::Schema::Resolver

  # include SearchObject for GraphQL
  include SearchObject.module(:graphql)

  # scope is starting point for search
  scope { Article.all }

  type [Types::ArticleType], null: true

  class ArticleFilter < ::Types::BaseInputObject

    argument :OR, [self], required: false
    argument :title_contains, String, required: false
    argument :body_contains, String, required: false
    argument :rating_is, Integer, required: false
  end

  option :filter, type: ArticleFilter, with: :apply_filter

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])

    scope = Article.all

    scope = scope.where('title LIKE ?', "%#{value[:title_contains]}%") if value[:title_contains]
    scope = scope.where('body LIKE ?', "%#{value[:body_contains]}%") if value[:body_contains]
    scope = scope.where('rating = ?', "#{value[:rating_is]}") if value[:rating_is]

    branches << scope

    value[:OR].reduce(branches) { |s, v| normalize_filters(v, s) } if value[:OR].present?

    branches
  end
end