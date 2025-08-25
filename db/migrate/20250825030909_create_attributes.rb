class CreateAttributes < ActiveRecord::Migration[8.0]
  def change
    create_table :attributes, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :attributes, :name, unique: true
    add_index :attributes, :slug, unique: true
  end
end
