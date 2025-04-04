class ReviewsController < ApplicationController
  before_action :set_purchase, only: [ :new, :create ]

  def create
    # TODO: Visit this url directly and check that if review has already been added it shows 404 or redirects back.
    # @purchase = purchase.find(params[:purchase_id])
    # @review = Review.new(review_params.merge(property_id:@purchase.property_id)) #for test

    @review = current_user.reviews.new(
      review_params.merge(
        product_id: @purchase.product_id,
        purchase_id: @purchase.id
      )
    )

    if @review.save
      redirect_to root_path, notice: "Review added successfully"
    else
      redirect_back fallback_location: root_path, alert: "Failed to add review"
    end
  end

  private
  # for not repetation the purchase line use set_purchase
  def set_purchase
    @purchase = Purchase.find(params[:purchase_id])
  end

  def review_params
    params.permit(
      :content,
      :fivestar_rating,
      :fourstar_rating,
      :threestar_rating,
      :twostar_rating,
      :onestar_rating
    )
  end
end
