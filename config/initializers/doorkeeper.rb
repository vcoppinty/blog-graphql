# frozen_string_literal: true

Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record

  resource_owner_from_credentials do
    user = User.find_by(email: params[:email])
    User.authenticate(user&.email, params[:password])
  end

  api_only

  access_token_expires_in 24.hours

  use_refresh_token

  enforce_configured_scopes

  grant_flows %w[password]

end
