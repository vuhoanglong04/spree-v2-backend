class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.string :code, null: false
      t.text :description
      t.integer :promotion_type, default: 0, null: false # fixed : 0, percentage : 1
      t.decimal :value, precision: 10, scale: 2, default: 0.0
      t.timestamp :start_date
      t.timestamp :end_date
      t.integer :usage_limit
      t.integer :per_user_limit
      t.decimal :min_order_amount, precision: 10, scale: 2, default: 0.0
      t.timestamp :deleted_at
      t.timestamps
    end
    add_index :promotions, :code, unique: true
  end
end
