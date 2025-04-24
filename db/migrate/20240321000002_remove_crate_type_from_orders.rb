class RemoveCrateTypeFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_reference :orders, :crate_type, foreign_key: true
  end
end 