class RemoveSubproductIdFromsizes < ActiveRecord::Migration[8.0]
  def change
    remove_column :sizes, :subproduct_id, :integer
  end
end
