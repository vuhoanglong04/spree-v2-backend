class AddStripeCouponIdToPromotions < ActiveRecord::Migration[8.0]
  def change
    add_column :promotions, :stripe_coupon_id, :string
    add_index  :promotions, :stripe_coupon_id, unique: true
  end
end
