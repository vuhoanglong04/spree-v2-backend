class OrderItemSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :quantity,
             :unit_price,
             :product_variant_snapshot
end
