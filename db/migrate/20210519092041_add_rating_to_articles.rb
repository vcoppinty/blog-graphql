class AddRatingToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :rating, :integer
  end
end
