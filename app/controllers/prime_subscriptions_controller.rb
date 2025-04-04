class PrimeSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  def create
    # Define Prime subscription details
    prime_price = 9999 # Example: $99.99 per year
    prime_name = "Amazon Prime Membership"

    # Create a Stripe price for the subscription
    stripe_price = Stripe::Price.create({
      currency: "usd",
      unit_amount: prime_price,
      recurring: { interval: "year" }, # Recurring annual subscription
      product_data: {
        name: prime_name
      }
    })

    # Generate success URL with user params
    success_url = url_for(
      controller: "prime_subscriptions",
      action: "success",
      only_path: false,
      user_id: current_user.id
    )

    # Create a Stripe Checkout session
    stripe_session = Stripe::Checkout::Session.create({
      success_url: success_url,
      line_items: [
        {
          price: stripe_price.id,
          quantity: 1
        }
      ],
      mode: "subscription"
    })

    # Redirect to Stripe Checkout
    redirect_to stripe_session.url, allow_other_host: true, status: 303
  end

  def success
    user = User.find(params[:user_id])

    # Update user to Prime member after successful payment
    user.update(prime_member: true)

    redirect_to root_path, notice: "You are now a Prime member!"
  end
end
