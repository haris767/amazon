class AddSubproductIdToSizes < ActiveRecord::Migration[8.0]
  def change
    add_reference :sizes, :subproduct, null: false, foreign_key: true
  end
end
