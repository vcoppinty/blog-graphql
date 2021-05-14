module Types
  class MutationType < Types::BaseObject
    # User Mutations
    field :create_user, mutation: Mutations::CreateUser
    field :sign_in_user, mutation: Mutations::SignInUser

    # Article Mutations
    field :create_article, mutation: Mutations::CreateArticle
    field :delete_article, mutation: Mutations::DeleteArticle
  end
end
