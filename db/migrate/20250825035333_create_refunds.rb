class CreateRefunds < ActiveRecord::Migration[8.0]
  def change
    create_table :refunds, id: :uuid do |t|
      t.uuid :payment_id, null: false
      t.string :stripe_refund_id, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.text :reason
      t.timestamp :last_synced_at
      t.text :raw_response
      t.timestamps
    end
    add_index :refunds, :payment_id
    add_index :refunds, :stripe_refund_id, unique: true
  end
end
