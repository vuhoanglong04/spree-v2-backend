class OrderSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :currency,
             :status,
             :total_amount,
             :refunded_amount,
             :promotion_id,
             :description,
             :created_at,
             :updated_at
  belongs_to :account_user, serializer: AccountUserSerializer
  has_many :order_items
  belongs_to :promotion, serializer: PromotionSerializer
end
