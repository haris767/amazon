class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :headline
      t.string :company_name
      t.string :description
      t.integer :price_cents
      t.string :price_currency
      t.string :country_code
      t.integer :size
      t.string :style
      t.string :color
      t.string :ear_placement
      t.string :form_factor
      t.string :impedance
      t.decimal :reviews_count
      t.decimal :average_final_rating
      t.references :subcategory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
