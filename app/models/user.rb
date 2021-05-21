class User < ApplicationRecord
  include Clearance::User

  #has_secure_password

  has_many :articles
  has_many :comments
  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
