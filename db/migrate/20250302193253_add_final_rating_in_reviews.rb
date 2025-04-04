class AddFinalRatingInReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :final_rating, :decimal
  end
end
