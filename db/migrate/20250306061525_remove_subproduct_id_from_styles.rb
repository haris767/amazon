class RemoveSubproductIdFromStyles < ActiveRecord::Migration[8.0]
  def change
    remove_column :styles, :subproduct_id, :integer
  end
end
