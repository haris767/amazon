class Product < ApplicationRecord
  belongs_to :subcategory
  has_rich_text :description
  has_many_attached :images
  has_many :reviews, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :purchased_users, through: :purchases, source: :user, dependent: :destroy
  scope :from_same_company, ->(company_name, product_id) { where(company_name: company_name).where.not(id: product_id) }
  #  has_many :sizes
  #  has_many :styles
  has_many :product_sizes, dependent: :destroy
  has_many :sizes, through: :product_sizes

  has_many :product_styles, dependent: :destroy
  has_many :styles, through: :product_styles

  has_many :product_payments, through: :purchases, dependent: :destroy
  validates :headline, presence: true
  validates :company_name, presence: true
  validates :description, presence: true
  monetize :price_cents, allow_nil: true
  validates :country_code, presence: true

   def update_average_rating
  average_rating = reviews.average(:final_rating)
  update_column(:average_final_rating, average_rating)
   end

def average_fivestar_rating
  reviews.average(:fivestar_rating)
end

def average_fourstar_rating
  reviews.average(:fourstar_rating)
end

def average_threestar_rating
  reviews.average(:threestar_rating)
end

def average_twostar_rating
  reviews.average(:twostar_rating)
end

def average_onestar_rating
  reviews.average(:onestar_rating)
end

# ###########################Percentage#######################
def review_percentages
  star_counts = {
    5 => reviews.sum(:fivestar_rating),
    4 => reviews.sum(:fourstar_rating),
    3 => reviews.sum(:threestar_rating),
    2 => reviews.sum(:twostar_rating),
    1 => reviews.sum(:onestar_rating)
  }

  total_ratings = star_counts.values.sum.to_f

  return { 5 => 0, 4 => 0, 3 => 0, 2 => 0, 1 => 0 } if total_ratings.zero?

  star_counts.transform_values { |count| ((count / total_ratings) * 100).round }
end

def discount_percentage
  return 0 unless discount_price.present? && price.present? && price.cents > 0

  discount = ((price.to_f - discount_price.to_f) / price.to_f) * 100
  discount.round(2) # Rounds to 2 decimal places
end
end
