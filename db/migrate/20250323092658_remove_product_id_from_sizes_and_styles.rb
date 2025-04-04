class RemoveProductIdFromSizesAndStyles < ActiveRecord::Migration[8.0]
  def change
    remove_column :sizes, :product_id, :integer
    remove_column :styles, :product_id, :integer
  end
end
