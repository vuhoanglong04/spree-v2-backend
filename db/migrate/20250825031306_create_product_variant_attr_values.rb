class CreateProductVariantAttrValues < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variant_attr_values do |t|
      t.references :product_variant, null: false, foreign_key: true
      t.references :product_attribute, null: false, foreign_key: true
      t.references :attribute_value, null: false, foreign_key: true
      t.timestamps
    end
    add_index :product_variant_attr_values, [:product_variant_id, :attribute_value_id], unique: true, name: 'idx_pv_attr_values_on_pv_and_av'
  end
end
