class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.string :content
      t.integer :fivestar_rating
      t.integer :fourstar_rating
      t.integer :threestar_rating
      t.integer :twostar_rating
      t.integer :onestar_rating
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
