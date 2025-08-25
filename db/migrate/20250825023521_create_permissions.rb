class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions , id: :uuid  do |t|
      t.string :action, null: false
      t.string :subject, null: false
      t.text :description
      t.timestamps
    end
  end
end
