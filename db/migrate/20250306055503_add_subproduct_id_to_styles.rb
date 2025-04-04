class AddSubproductIdToStyles < ActiveRecord::Migration[8.0]
  def change
    add_reference :styles, :subproduct, null: false, foreign_key: true
  end
end
