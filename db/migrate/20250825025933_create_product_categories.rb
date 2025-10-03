class CreateProductCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :product_categories, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.integer :category_id, null: false
      t.timestamps
    end
    add_index :product_categories, [:product_id, :category_id]
    add_index :product_categories, :category_id
  end
end
