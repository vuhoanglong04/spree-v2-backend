class PromotionSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :code,
             :promotion_type,
             :value,
             :usage_limit,
             :min_order_amount,
             :description,
             :per_user_limit,
             :stripe_coupon_id,
             :start_date,
             :end_date,
             :deleted_at,
             :created_at,
             :updated_at
end
