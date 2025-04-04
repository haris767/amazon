class AddOrderReferenceToproductPayments < ActiveRecord::Migration[8.0]
  def change
    add_reference :product_payments, :order, foreign_key: true
  end
end
