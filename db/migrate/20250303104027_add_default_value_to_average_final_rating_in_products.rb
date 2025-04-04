class AddDefaultValueToAverageFinalRatingInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :average_final_rating, :decimal, default: 0
  end
end
