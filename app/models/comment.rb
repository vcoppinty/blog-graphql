class Comment < ApplicationRecord

  belongs_to :article
  belongs_to :user

  validates :body, presence: true, length: {minimum: 3, maximum:20}
  validates :rating, presence: true, inclusion: 1..10
end
