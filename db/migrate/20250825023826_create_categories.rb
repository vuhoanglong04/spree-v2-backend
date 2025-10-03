class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :ancestry
      t.integer :position, null: false, default: 0
      t.timestamp :deleted_at
      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :name
    add_index :categories, :ancestry
  end
end
