class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_method
      t.string :transaction_id
      t.string :status
      t.integer :amount_cents
      t.string :currency, default: 'USD'
      t.datetime :processed_at

      t.timestamps
    end

    add_index :payments, :transaction_id, unique: true
  end
end 