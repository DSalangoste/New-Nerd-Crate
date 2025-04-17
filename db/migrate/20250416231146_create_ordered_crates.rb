class CreateOrderedCrates < ActiveRecord::Migration[7.1]
  def change
    create_table :ordered_crates do |t|
      t.references :order, null: false, foreign_key: true
      t.references :crate_type, null: false, foreign_key: true
      t.string :status
      t.jsonb :customization_options

      t.timestamps
    end
  end
end
