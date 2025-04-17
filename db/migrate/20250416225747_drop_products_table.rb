class DropProductsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :products, force: :cascade
  end

  def down
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :category
      t.timestamps
    end
  end
end
