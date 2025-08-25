class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
    add_index :roles, :name, unique: true
  end
end
