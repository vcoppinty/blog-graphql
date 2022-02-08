class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user
      t.references :article
      t.text :body
      t.integer :rating

      t.timestamps
    end
  end
end
