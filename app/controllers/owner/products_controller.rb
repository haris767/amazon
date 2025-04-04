module Owner
  class ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product, only: [ :edit, :update, :add_images, :remove_image, :destroy ]

    def new
      @product = Product.new
    end

    def create
      @product = current_user.products.create!(product_params)

      redirect_to edit_owner_product_path(@product), notice: "product added successfully"
    end

    def index
      @products = current_user.products.order(created_at: :desc)
    end

    def update
      if @product.update!(product_params)
        redirect_to edit_owner_product_path, notice: "product updated successfully"
      else
        redirect_back fallback_location: edit_owner_product_path, alert: "Failed to update product"
      end
    end

    def update_sizes
      set_product
      if @product.update(size_ids: params[:product][:size_ids])
        redirect_to edit_owner_product_path(@product), notice: "Sizes updated successfully"
      else
        redirect_back fallback_location: edit_owner_product_path(@product), alert: "Failed to update sizes"
      end
    end

    def update_styles
      set_product
      if @product.update(style_ids: params[:product][:style_ids])
        redirect_to edit_owner_product_path(@product), notice: "Styles updated successfully"
      else
        redirect_back fallback_location: edit_owner_product_path(@product), alert: "Failed to update styles"
      end
    end



    def add_images
      # TODO: Possibly optimise this if no images are selected.
      @product.images.attach(params[:product][:images])
      redirect_to edit_owner_product_path, notice: "product images uploaded"
    end

    def remove_image
      image = @product.images.find(params[:image_id])
      if image.destroy!
        redirect_to edit_owner_product_path, notice: "Image removed successfully"
      else
        redirect_back fallback_location: edit_owner_product_path, alert: "Failed to remove image"
      end
    end


    def destroy
      @product.destroy
      redirect_to owner_products_path, alert: "#{@product.name} deleted successfully."
    end

    private

    def set_product
      @product = current_user.products.find(params[:id])
      @size = @product.sizes.first # Assign the first size of the product
      @style = @product.styles.first # Assign the first style of the product
    end

    def sizes_params
      params.require(:product).permit(size_ids: [])
    end

    def styles_params
      params.require(:product).permit(style_ids: [])
    end


    def product_params
      params.require(:product).permit(
        :headline,
        :price,
        :description,
        :country_code
      )
    end
  end
end
