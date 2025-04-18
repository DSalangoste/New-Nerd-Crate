class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.decimal :tax_rate, precision: 5, scale: 2, null: false

      t.timestamps
    end
    
    add_index :provinces, :code, unique: true
  end
end 