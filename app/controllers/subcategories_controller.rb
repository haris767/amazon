class SubcategoriesController < ApplicationController
    def index
    @category = Category.find(params[:category_id])  # Get the specific category
    @subcategories = @category.subcategories # Category.first.subcategories
    end
end
