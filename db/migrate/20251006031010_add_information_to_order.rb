class AddInformationToOrder < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :address, :string
    add_column :orders, :email, :string
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :phone_number, :string
    remove_column :orders, :currency, :string
  end
end
