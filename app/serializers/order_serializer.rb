class OrderSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :account_user_id,
             :total_amount,
             :status,
             :address,
             :first_name,
             :last_name,
             :email,
             :phone_number,
             :refunded_amount,
             :promotion_id,
             :description,
             :updated_at,
             :created_at
  has_many :order_items
end
