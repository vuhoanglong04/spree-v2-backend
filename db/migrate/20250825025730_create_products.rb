class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :brand
      t.bigint :favourite_count
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :products, :name, unique: true
    add_index :products, :slug, unique: true
  end
end
