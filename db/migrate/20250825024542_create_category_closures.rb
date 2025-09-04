class CreateCategoryClosures < ActiveRecord::Migration[8.0]
  def change
    create_table :category_closures, id: false do |t|
      t.uuid :ancestor, null: false
      t.uuid :descendant, null: false
      t.integer :depth, null: false
      t.timestamps
    end
    add_foreign_key :category_closures, :categories, column: :ancestor, primary_key: :id
    add_foreign_key :category_closures, :categories, column: :descendant, primary_key: :id

    # Indexes
    add_index :category_closures, [:ancestor, :descendant], unique: true
    add_index :category_closures, :descendant
  end
end
