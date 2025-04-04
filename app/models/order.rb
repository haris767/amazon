class Order < ApplicationRecord
  belongs_to :user
  has_many :purchases
  has_many :product_payments
  # validates :carrier_name, presence: true  # Optional: validate presence if required
  # Fetch the most recent order for tracking
  def self.most_recent_for_user(user)
    user.orders.order(created_at: :desc).first
  end
end
