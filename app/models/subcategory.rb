class Subcategory < ApplicationRecord
  validates :name, presence: true
  belongs_to :category
  has_one_attached :image
  has_many :products, dependent: :destroy
end
