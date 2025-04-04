class RemoveFinalRatingInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :final_rating
  end
end
