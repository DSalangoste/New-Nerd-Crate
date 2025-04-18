class AddCheckoutFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    # Update existing status column if it exists, otherwise add it
    if column_exists?(:orders, :status)
      change_column_default :orders, :status, 'cart'
    else
      add_column :orders, :status, :string, default: 'cart'
    end

    # Add other columns only if they don't exist
    add_column :orders, :payment_status, :string unless column_exists?(:orders, :payment_status)
    add_column :orders, :payment_intent_id, :string unless column_exists?(:orders, :payment_intent_id)
    add_column :orders, :payment_method_id, :string unless column_exists?(:orders, :payment_method_id)
    add_column :orders, :subtotal_cents, :integer unless column_exists?(:orders, :subtotal_cents)
    add_column :orders, :tax_cents, :integer unless column_exists?(:orders, :tax_cents)
    add_column :orders, :shipping_cents, :integer unless column_exists?(:orders, :shipping_cents)
    add_column :orders, :total_cents, :integer unless column_exists?(:orders, :total_cents)
    add_column :orders, :shipping_method, :string unless column_exists?(:orders, :shipping_method)
    add_column :orders, :notes, :text unless column_exists?(:orders, :notes)
    add_column :orders, :completed_at, :datetime unless column_exists?(:orders, :completed_at)
  end
end 