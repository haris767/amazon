class Size < ApplicationRecord
  # belongs_to :product
  #
  has_many :product_sizes, dependent: :destroy
  has_many :products, through: :product_sizes
end
