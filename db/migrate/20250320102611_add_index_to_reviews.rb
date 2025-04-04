class AddIndexToReviews < ActiveRecord::Migration[8.0]
  def change
    add_index :reviews, [ :user_id, :product_id, :purchase_id ], unique: true
  end
end
