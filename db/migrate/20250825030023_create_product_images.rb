class CreateProductImages < ActiveRecord::Migration[8.0]
  def change
    create_table :product_images, id: :uuid do |t|
      t.uuid :product_id, null: false
      t.text :url, null: false
      t.string :alt, default: "product"
      t.integer :position
      t.timestamps
    end
  end
end
