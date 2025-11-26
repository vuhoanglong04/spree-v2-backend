class CreateProductAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :product_attributes do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :product_attributes, :name, unique: true
    add_index :product_attributes, :slug, unique: true
  end
end
