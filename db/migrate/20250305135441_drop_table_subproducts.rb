class DropTableSubproducts < ActiveRecord::Migration[8.0]
  def change
    drop_table :subproducts
  end
end
