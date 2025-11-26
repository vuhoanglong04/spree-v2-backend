class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :account_user, null: false, foreign_key: true
      t.string :currency, default: 'USD'
      t.integer :status, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :refunded_amount, precision: 10, scale: 2, default: 0.0
      t.references :promotion, foreign_key: true
      t.text :description
      t.timestamps
    end
  end
end
