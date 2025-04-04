class RemovePriceCentsCentsInProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :price_cents_cents
    remove_column :products, :price_cents_currency
  end
end
