module Mutations
  class SignInUser < BaseMutation
    field :access_token, Types::AccessTokenType, null: true

    argument :email, String, required: true
    argument :password, String, required: true

    def resolve(email:, password:)
      user = User.authenticate(email, password)
      access_token = user&.access_tokens&.create!(
        application_id: Doorkeeper::Application.first.id,
        expires_in: 1.day
      )
      { access_token: access_token}
    end
  end
end