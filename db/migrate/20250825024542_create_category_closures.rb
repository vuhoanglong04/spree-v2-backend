class CreateCategoryClosures < ActiveRecord::Migration[8.0]
  def change
    create_table :category_closures do |t|
      t.uuid :ancestor, null: false
      t.uuid :descendant, null: false
      t.integer :depth, null: false
      t.timestamps
    end
    add_index :category_closures, [:ancestor, :descendant], unique: true
    add_index :category_closures, :descendant
  end
end
