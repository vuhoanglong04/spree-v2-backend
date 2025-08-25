class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.integer :cart_id, null: false
      t.integer :product_variant_id, null: false
      t.integer :quantity, null: false
      t.timestamps
    end
    add_index :cart_items, [:cart_id, :product_variant_id], unique: true
  end
end
