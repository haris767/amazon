class RemoveStyleIdInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :style_id, :integer
  end
end
