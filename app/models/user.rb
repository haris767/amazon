class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :purchased_products, through: :purchases, source: :property, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :product_payments, through: :reservations, dependent: :destroy
  validates :name, presence: true
  validates :tracking_number, presence: true
  validates :carrier_name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         attribute :prime_member, :boolean, default: false
        def prime_eligible?
          prime_member || eligible_for_free_shipping?
        end

        def eligible_for_free_shipping?
          completed_orders_count >= 5 || total_spent >= 50.00
        end

        private

        def completed_orders_count
          orders.where(status: "completed").count
        end

        def total_spent
          orders.where(status: "completed").sum(:total_price)
        end
end
