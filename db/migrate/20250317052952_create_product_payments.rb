class CreateProductPayments < ActiveRecord::Migration[8.0]
  def change
    create_table :product_payments do |t|
      t.integer :total_price_cents
      t.string :total_price_currency
      t.integer :product_price_cents
      t.string :product_price_currency
      t.references :purchase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
