class CreateReturnRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :return_requests do |t|
      t.references :order, null: false, foreign_key: true
      t.references :order_item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.text :reason
      t.integer :status, default: 0, null: false   # 'requested','approved','rejected','received','refunded'
      t.timestamps
    end
  end
end
