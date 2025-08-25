class CreateReturnRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :return_requests, id: :uuid do |t|
      t.integer :order_id, null: false
      t.integer :order_item_id, null: false
      t.integer :quantity, null: false
      t.text :reason
      t.integer :status, default: 0, null: false   #'requested','approved','rejected','received','refunded'
      t.timestamps
    end
  end
end
