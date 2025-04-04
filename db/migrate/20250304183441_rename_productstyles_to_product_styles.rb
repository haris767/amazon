class RenameProductstylesToProductStyles < ActiveRecord::Migration[8.0]
  def change
    rename_table :productstyles, :product_styles
  end
end
