class OrderSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :account_user_id,
             :currency,
             :total_amount,
             :status,
             :refunded_amount,
             :promotion_id,
             :description,
             :updated_at,
             :created_at
  has_many :order_items
end
