class RemoveDropProductsSizesJoinTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :products_sizes
  end
end
