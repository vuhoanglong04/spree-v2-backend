class CreateUserProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_profiles, id: :uuid do |t|
      t.integer :user_id, null: false
      t.string :full_name, null: false
      t.string :phone, null: false
      t.text :avatar_url, default: "https://robohash.org/hicdoloresiure.png?size=300x300&set=set1"
      t.string :locale, default: "en"
      t.string :time_zone, default: "Pacific Time (US & Canada)"
      t.timestamps
    end
  end
end
