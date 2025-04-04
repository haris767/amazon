class Style < ApplicationRecord
  # belongs_to :product
  has_many :product_styles, dependent: :destroy
  has_many :products, through: :product_styles
end
