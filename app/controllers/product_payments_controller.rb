class ProductPaymentsController < ApplicationController
  def create
    @product = Product.find(product_payments_params[:product_id])


    # Convert total price to cents
    total_price_cents = (product_payments_params[:total_price].to_f * 100).to_i

    # Stripe price creation
    stripe_price = Stripe::Price.create({
      currency: "usd",
      unit_amount: total_price_cents,
      product_data: {
        name: @product.headline # Change 'headline' to 'name'
      }
    })

    # Success URL
    success_url = url_for(
      controller: "product_payments",
      action: "success",
      only_path: false,
      product_payments_params: product_payments_params.except(:stripeToken),
    )

    # Cancel URL
    cancel_url = root_url # Redirect to root if user cancels

    # Create Stripe Checkout Session
    stripe_session = Stripe::Checkout::Session.create({
      success_url: success_url,
      cancel_url: cancel_url,
      customer_email: current_user.email, # Send user email to Stripe
      line_items: [
        {
          price: stripe_price.id,
          quantity: product_payments_params[:quantity].to_i
        }
      ],
      mode: "payment"
    })

    # Redirect to Stripe checkout page
    redirect_to stripe_session.url, allow_other_host: true, status: 303
  end

  def success
    product_payments_params = params[:product_payments_params] # Fix variable name


    #   carrier_name = params[:carrier_name]

    # if carrier_name.blank?
    #   redirect_to root_path, alert: "Please select a carrier before checkout."
    #   return
    # end

    product = Product.find(product_payments_params[:product_id])
    # ✅ Create an order if one is not being created

    order = Order.create!(
      user_id: current_user.id,
      total_price: product_payments_params[:total_price].to_f,
      status: "pending",
      # carrier_name: carrier_name  # Store carrier name
    )
    # Create purchase record
    purchase = Purchase.create!(
      user_id: current_user.id,
      product_id: product.id,
      quantity: product_payments_params[:quantity].to_i,
      order_id: order.id
    )

    # Create ProductPayment record
    ProductPayment.create!(
      purchase_id: purchase.id,
      product_id: product.id,
      product_price_cents: (product.price).to_i,
      total_price_cents: (product_payments_params[:total_price].to_f * 100).to_i,
      order_id: order.id  # Make sure you associate the order
    )

     # Update order total price
     order.update(total_price:  (product_payments_params[:total_price]).to_i)


    redirect_to root_path
  end

  private

  def product_payments_params
    params.permit(:stripeToken, :product_id, :quantity, :total_price)
    # params.require(:product_payments_params).permit(:carrier_name)
  end
end
