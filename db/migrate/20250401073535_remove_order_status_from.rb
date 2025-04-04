class RemoveOrderStatusFrom < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :order_status
  end
end
