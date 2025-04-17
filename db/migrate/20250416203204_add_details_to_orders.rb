class AddDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_address, :text
    add_column :orders, :payment_status, :string
    add_column :orders, :tracking_number, :string
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
  end
end
