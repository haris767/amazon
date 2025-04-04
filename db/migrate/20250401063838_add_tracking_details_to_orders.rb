class AddTrackingDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :tracking_number, :string
    add_column :orders, :carrier_name, :string
    add_column :orders, :tracking_status, :string
  end
end
