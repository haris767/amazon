class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :purchase
  validates :content, presence: :true
  # these all are rating between 1 to 5 so that's why we use numericality to tell the range in between user can rate
  validates :fivestar_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :fourstar_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :threestar_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :twostar_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :onestar_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  after_commit :update_final_rating, on: [ :create, :update ]

   def update_final_rating
    total_points = fivestar_rating +
    fourstar_rating +
    threestar_rating +
    twostar_rating +
    onestar_rating
    update_column(:final_rating, total_points.to_f / 5)

    product.update_average_rating
   end
end
