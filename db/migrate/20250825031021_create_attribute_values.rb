class CreateAttributeValues < ActiveRecord::Migration[8.0]
  def change
    create_table :attribute_values, id: :uuid do |t|
      t.uuid :attribute_id, null: false
      t.string :value, null: false
      t.string :extra
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
