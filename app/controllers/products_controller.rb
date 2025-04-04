class ProductsController < ApplicationController
  def index
    @subcategory = Subcategory.find(params[:subcategory_id])  # Get the specific subcategory
    @products = @subcategory.products.includes(:reviews)  # Fetch products of this subcategory # Subcategory.first.products

    @products.each do |product|
      product.instance_variable_set(:@review_percentages, product.review_percentages)
    end
    # Debugging logs
    # Rails.logger.debug "Min Price: #{params[:min_price]}"
    # Rails.logger.debug "Max Price: #{params[:max_price]}"
    # Price filtering logic 
    if params[:min_price].present? && params[:max_price].present?
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      # Ensure min_price and max_price are numeric and the query can handle the price range
      @products = @products.where(price: min_price..max_price)
    end

    respond_to do |format|
      format.html # Regular page load
      format.json { render json: @products } # JSON response if needed
      format.turbo_stream { render turbo_stream: turbo_stream.replace("product_list", template: "products/index") }
    end
  end

  def show
    @product = Product.includes(:reviews).find(params[:id])
    # showing all poducts below
    @subcategory = Subcategory.find(params[:subcategory_id])  # Get the specific subcategory
    @products = @subcategory.products.includes(:reviews)  # Fetch products of this subcategory # Subcategory.first.products
    @related_products = Product.from_same_company(@product.company_name, @product.id)
    @sizes = Size.all
    @styles = Style.all
    @size = @product.sizes.first|| Size.new(name: "Default") # Default to the first size
    @style = @product.styles.first|| Style.new(name: "Default") # Default to the first size
    @tomorrow_date = (Date.today + 3).strftime("%A, %B %d") # Example: "Thursday, March 16"
    # raise
  end
  def get_image
    product = Product.find(params[:id])
    image_name = params[:image_name]

    # Find the correct image in Active Storage
    image = product.images.find { |img| img.filename.to_s == image_name }

    if image
      render json: { image_url: url_for(image) }
    else
      render json: { error: "Image not found" }, status: :not_found
    end
  end
end
