class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  has_one :product_payment
  has_one :review

  validates :quantity, presence: true
end
