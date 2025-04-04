class CreateProductstyles < ActiveRecord::Migration[8.0]
  def change
    create_table :productstyles do |t|
      t.references :product, null: false, foreign_key: true
      t.references :style, null: false, foreign_key: true
      t.integer :stock

      t.timestamps
    end
  end
end
