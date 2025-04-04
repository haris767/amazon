class Add < ActiveRecord::Migration[8.0]
  def change
    add_column :subproducts, :country_name, :string
  end
end
