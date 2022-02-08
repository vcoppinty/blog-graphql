# frozen_string_literal: true

module Types
  class MutationErrorType < Types::BaseObject
    field :key, String, null: true
    field :message, String, null: true
  end
end