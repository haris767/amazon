class DropProductStylessTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :product_styles
  end
end
