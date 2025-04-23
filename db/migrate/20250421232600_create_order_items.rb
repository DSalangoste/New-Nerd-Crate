class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :crate_type, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :price_cents, null: false

      t.timestamps
    end
  end
end 