class RemoveCrateTypeIdConstraintFromOrders < ActiveRecord::Migration[7.0]
  def change
    # Remove the not-null constraint from crate_type_id
    change_column_null :orders, :crate_type_id, true
    # Remove the foreign key if it exists
    remove_foreign_key :orders, :crate_types rescue nil
    # Remove the column since we use order_items association instead
    remove_column :orders, :crate_type_id
  end
end 