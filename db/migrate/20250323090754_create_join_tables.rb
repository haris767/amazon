class CreateJoinTables < ActiveRecord::Migration[8.0]
  def change
    create_table :product_sizes do |t|
      t.references :product, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true
      t.timestamps
    end

    create_table :product_styles do |t|
      t.references :product, null: false, foreign_key: true
      t.references :style, null: false, foreign_key: true
      t.timestamps
    end
  end
end
