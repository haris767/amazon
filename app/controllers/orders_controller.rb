class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def create
    # Assuming current_user is logged in and the product details are already set
    order = current_user.orders.create!(
      status: "pending",  # Initially setting status to 'pending'
      carrier_name: params[:order][:carrier_name],  # Capture the selected carrier name
      total_price: params[:total_price]  # Set total price (you may have calculated this elsewhere)
    )

    # Redirect to payment or order confirmation page
    redirect_to checkout_path(order)
  end

  def show
    # @order = current_user.orders.find(params[:id])


    if params[:id] == "most_recent"
      @order = current_user.orders.order(created_at: :desc).first  # Fetch the most recent order
      @order.fetch_tracking_update if @order.tracking_number.present?
    else
      @order = current_user.orders.find(params[:id])  # Fetch a specific order by ID
    end
  end


  def most_recent
    @order = Order.most_recent_for_user(current_user)
    if @order
      # Show recent order tracking
      render :show
    else
      redirect_to orders_path, notice: "No recent orders found."
    end
  end
end
