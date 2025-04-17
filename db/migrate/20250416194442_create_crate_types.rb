class CreateCrateTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :crate_types do |t|
      t.string :name
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
