class CreateUserRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_roles do |t|
      t.uuid :account_user_id, null: false
      t.uuid :role_id, null: false
      t.timestamps
    end
    add_index :user_roles, [:account_user_id, :role_id], unique: true
  end
end
