class BuyProductController < ApplicationController
  before_action :authenticate_user!
def update_shipping
 # country = params[:country]
 country = params[:country].presence || "default"
  user = current_user
  @product = Product.find_by(id: params[:product_id])


  if @product.nil?
    render json: { error: "Couldn't find Product with ID #{params[:product_id]}" }, status: 404
    return
  end
  quantity = params[:quantity].to_i
  total_price = params[:total_price].to_f

  # Determine Free Shipping Eligibility
  free_shipping = user&.prime_eligible?

  # Define Shipping Rates
  shipping_rates = {
    "US" => {
      standard: { cost: free_shipping ? 0.0 : 10.0, delivery_date: (Date.today + 3).strftime("%A, %B %d") },
      expedited: { cost: free_shipping ? 0.0 : 20.0, delivery_date: (Date.today + 2).strftime("%A, %B %d") },
      same_day: { cost: free_shipping ? 0.0 : 30.0, delivery_date: (Date.today + 0).strftime("%A, %B %d") }
    },
    "UK" => {
      standard: { cost: free_shipping ? 0.0 : 15.0, delivery_date: (Date.today + 5).strftime("%A, %B %d") },
      expedited: { cost: free_shipping ? 0.0 : 25.0, delivery_date: (Date.today + 3).strftime("%A, %B %d") },
      same_day: { cost: free_shipping ? 0.0 : 35.0, delivery_date: (Date.today + 1).strftime("%A, %B %d") }
    },
    "AU" => {
      standard: { cost: free_shipping ? 0.0 : 20.0, delivery_date: (Date.today + 7).strftime("%A, %B %d") },
      expedited: { cost: free_shipping ? 0.0 : 30.0, delivery_date: (Date.today + 5).strftime("%A, %B %d") },
      same_day: { cost: free_shipping ? 0.0 : 40.0, delivery_date: (Date.today + 2).strftime("%A, %B %d") }
    }
  }

  # Default rates for other countries
  rates = shipping_rates[country] || {
    standard: { cost: free_shipping ? 0.0 : 50.0, delivery_date: (Date.today + 14).strftime("%A, %B %d") },
    expedited: { cost: free_shipping ? 0.0 : 70.0, delivery_date: (Date.today + 10).strftime("%A, %B %d") },
    same_day: { cost: free_shipping ? 0.0 : 90.0, delivery_date: (Date.today + 3).strftime("%A, %B %d") }
  }
 # @quantity = quantity
 #   @total_price = total_price
 # Return JSON response
 render json: { shipping_rates: rates, quantity: { value: quantity }, total_price: { value: total_price }  }
#  render "update_shipping" # This ensures the correct view is rendered
#  redirect_to update_shipping_buy_product_path(product_id: @product.id, quantity: @quantity, style: @style, shipping_cost: @shipping_cost, total_price: @total_price)

rescue StandardError => e
  render json: { error: e.message }, status: 500
end

   def new
    @product = Product.find_by(id: params[:product_id])
    quantity = params[:quantity].to_i
    total_price = params[:total_price].to_f
    @quantity = quantity
    @total_price = total_price
  # Find style and size by name instead of ID
  # @style = Style.find_by(name: params[:style], product_id: params[:product_id])
  # @size = Size.find_by(name: params[:size], product_id: params[:product_id])
  @size = params[:size]
  @style = params[:style]
  @quantity = quantity
  @total_price = total_price
      render "new"
     # render json: @size
     # render json:  { quantity: { value: quantity }, total_price: { value: total_price } }
   end

  def empty_cart
    session[:cart] = {} # Reset cart stored in session
    redirect_to root_path, notice: "Cart has been emptied successfully."
  end



  def buy_product_params
    params.permit(:product_id, :quantity, :total_price)
  end
end
