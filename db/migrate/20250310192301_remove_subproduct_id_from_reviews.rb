class RemoveSubproductIdFromReviews < ActiveRecord::Migration[8.0]
  def change
    remove_column :reviews, :subproduct_id, :integer
  end
end
