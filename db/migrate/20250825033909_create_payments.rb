class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments, id: :uuid do |t|
      t.uuid :order_id, null: false
      t.string :stripe_payment_id, null: false
      t.string :stripe_charge_id
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.string :currency, default: "USD"
      t.integer :status, default: 0, null: false
      t.decimal :amount_refunded, precision: 10, scale: 2, default: 0.00
      t.timestamp :last_synced_at
      t.text :raw_response
      t.timestamps
    end
    add_index :payments, :order_id
    add_index :payments, :stripe_payment_id, unique: true
    add_index :payments, :stripe_charge_id, where: "stripe_charge_id IS NOT NULL"
  end
end
