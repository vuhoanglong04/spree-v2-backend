class OrderItemSerializer < ActiveModel::Serializer
  attributes :id,
             :product_variant_id,
             :name,
             :sku,
             :unit_price,
             :product_variant_snapshot
end
