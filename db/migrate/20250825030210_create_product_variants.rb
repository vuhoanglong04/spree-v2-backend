class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku, null: false
      t.string :name, null: false
      t.decimal :origin_price, precision: 10, scale: 2, default: 0.0
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.integer :stock_qty, default: 0
      t.string :stripe_product_id
      t.string :stripe_price_id
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :product_variants, :sku, unique: true
    add_index :product_variants, :name, unique: true
  end
end
