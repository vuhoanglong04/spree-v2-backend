class CreateAttributeValues < ActiveRecord::Migration[8.0]
  def change
    create_table :attribute_values do |t|
      t.references :product_attribute, null: false, foreign_key: true
      t.string :value, null: false
      t.string :extra
      t.timestamps
    end
  end
end
