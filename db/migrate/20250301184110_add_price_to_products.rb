class AddPriceToProducts < ActiveRecord::Migration[8.0]
  def change
    add_monetize :products, :price_cents, amount: { null: true, default: nil }, currency: { null: true, default: nil }
  end
end
