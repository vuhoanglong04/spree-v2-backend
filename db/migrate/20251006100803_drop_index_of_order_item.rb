class DropIndexOfOrderItem < ActiveRecord::Migration[8.0]
  def change
    remove_index :order_items, :order_id
    add_index :order_items, :order_id
  end
end
