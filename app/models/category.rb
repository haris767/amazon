class Category < ApplicationRecord
  validates :name, presence: true
  has_many :subcategories, dependent: :destroy
end
