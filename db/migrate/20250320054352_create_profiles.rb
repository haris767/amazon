class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :country_code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
