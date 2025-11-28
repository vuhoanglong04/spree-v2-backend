class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :action_name, null: false
      t.string :subject, null: false
      t.text :description
      t.timestamps
    end
    add_index :permissions, [ :subject, :action_name ], unique: true
  end
end
