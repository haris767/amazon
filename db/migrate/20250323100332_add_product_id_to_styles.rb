class AddProductIdToStyles < ActiveRecord::Migration[8.0]
  def change
    add_reference :styles, :product, foreign_key: true
  end
end
