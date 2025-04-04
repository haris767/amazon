class ProductPayment < ApplicationRecord
  belongs_to :purchase
  belongs_to :order


    monetize :product_price_cents, numericality: { greater_than: 0 }
    monetize :total_price_cents, numericality: { greater_than: 0 }
end
