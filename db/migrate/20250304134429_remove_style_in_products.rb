class RemoveStyleInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :style
  end
end
