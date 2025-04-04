class UpdateReviewsCountInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :reviews_count, :decimal
  end
end
