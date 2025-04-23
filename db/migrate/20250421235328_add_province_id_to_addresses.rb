class AddProvinceIdToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_reference :addresses, :province, null: false, foreign_key: true
    remove_column :addresses, :state, :string
  end
end
