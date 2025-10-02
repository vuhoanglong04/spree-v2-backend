class AddTotalSoldToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :total_sold, :integer, default: 0
  end
end
