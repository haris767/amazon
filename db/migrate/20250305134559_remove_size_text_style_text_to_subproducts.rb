class RemoveSizeTextStyleTextToSubproducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :subproducts, :size_text
    remove_column :subproducts, :style_text
  end
end
