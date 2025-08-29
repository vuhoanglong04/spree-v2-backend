class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items, id: :uuid do |t|
      t.uuid :order_id, null: false
      t.uuid :product_variant_id, null: false
      t.string :name, null: false
      t.string :sku, null: false
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, default: 0.0
      t.text :product_variant_snapshot
      t.timestamps
    end
    add_index :order_items, :order_id, unique: true
  end
end
