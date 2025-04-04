class RemoveSizeTextStyleTextInSubproducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :size_text
    remove_column :products, :style_text
  end
end
