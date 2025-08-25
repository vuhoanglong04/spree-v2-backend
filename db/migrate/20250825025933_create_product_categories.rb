class CreateProductCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :product_categories do |t|
      t.integer :product_id, null: false
      t.integer :category_id, null: false
      t.timestamps
    end
    add_index :product_categories, [:product_id, :category_id], unique: true
    add_index :product_categories, :category_id, unique: true
  end
end
