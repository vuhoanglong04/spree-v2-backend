class CreateProductVariantAttrValues < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variant_attr_values do |t|
      t.integer :product_variant_id, null: false
      t.integer :attribute_id, null: false
      t.integer :attribute_value_id, null: false
      t.timestamps
    end
    add_index :product_variant_attr_values, [:product_variant_id, :attribute_id], unique: true
  end
end
