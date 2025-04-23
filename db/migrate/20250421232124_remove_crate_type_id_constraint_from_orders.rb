class RemoveCrateTypeIdConstraintFromOrders < ActiveRecord::Migration[7.1]
  def change
    # Remove the not-null constraint from crate_type_id
    change_column_null :orders, :crate_type_id, true
  end
end
