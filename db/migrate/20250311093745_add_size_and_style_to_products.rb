class AddSizeAndStyleToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :size, :string
    add_column :products, :style, :string
  end
end
