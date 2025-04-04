class AddProductIdToProductPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :product_payments, :product_id, :integer
  end
end
