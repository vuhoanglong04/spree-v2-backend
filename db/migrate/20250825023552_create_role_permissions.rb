class CreateRolePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :role_permissions do |t|
      t.integer :role_id, null: false
      t.integer :permission_id, null: false
      t.timestamps
    end
    add_index :role_permissions, [:role_id, :permission_id], unique: true
  end
end
