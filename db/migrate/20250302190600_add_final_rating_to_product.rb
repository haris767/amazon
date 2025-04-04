class AddFinalRatingToProduct < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :final_rating, :decimal
  end
end
