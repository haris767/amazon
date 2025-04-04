class AddProductidToSizessStyles < ActiveRecord::Migration[8.0]
  def change
    add_reference :sizes, :product, foreign_key: true
    add_reference :styles, :product, foreign_key: true
  end
end
