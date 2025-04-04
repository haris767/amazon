class RemoveDeliveryColumnFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :delivery
  end
end
