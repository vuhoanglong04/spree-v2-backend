class CreateUserIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_identities, id: :uuid do |t|
      t.integer :user_id, null: false
      t.string :provider, null: false
      t.string :provider_uid, null: false
      t.timestamps
    end
    add_index :user_identities, [:provider, :provider_uid], unique: true
  end
end
