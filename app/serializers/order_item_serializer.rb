class OrderItemSerializer < ActiveModel::Serializer
  attributes :id,
             :product_variant_id,
             :name,
             :sku,
             :product_variant_image,
             :unit_price,
             :product_variant_snapshot

  def product_variant_image
    object&.product_variant&.product&.product_images[0]&.url
  end
end
