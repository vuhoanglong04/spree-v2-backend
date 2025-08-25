class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.integer :user_id, null: false
      t.string :currency, default: 'USD'
      t.integer :status, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :refunded_amount, precision: 10, scale: 2, default: 0.0
      t.integer :promotion_id
      t.text :description
      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :promotion_id, where: "promotion_id IS NOT NULL"
  end
end
