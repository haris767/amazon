class AddSubproductIdToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :subproduct_id, :integer
    add_index :reviews, :subproduct_id
  end
end
