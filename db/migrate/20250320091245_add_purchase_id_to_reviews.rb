class AddPurchaseIdToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :purchase_id, :integer
  end
end
