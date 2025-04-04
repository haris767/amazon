class AddHeadlineDescriptionCountryNameCompanyNameEarPlacementFormFactorImpedancePriceReviewsCountAverageFinalRatingColorInSubproducts < ActiveRecord::Migration[8.0]
  def change
        add_column :subproducts, :headline, :string
        add_column :subproducts, :description, :text
        add_column :subproducts, :country_name, :string
        add_column :subproducts, :company_name, :string
        add_column :subproducts, :color, :string
        add_column :subproducts, :ear_placement, :string
        add_column :subproducts, :form_factor, :string
        add_column :subproducts, :impedance, :string
        add_column :subproducts, :reviews_count, :integer, default: 0
        add_column :subproducts, :average_final_rating, :float, default: 0.0
  end
end
