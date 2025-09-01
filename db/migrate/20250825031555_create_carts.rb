class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts , id: :uuid do |t|
      t.uuid :account_user_id, null: false
      t.timestamps
    end
  end
end
