class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.uuid :parent_id
      t.integer :position, null: false, default: 0
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :categories, :slug
    add_index :categories, :name
  end
end
