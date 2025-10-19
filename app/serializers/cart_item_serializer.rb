class CartItemSerializer < ActiveModel::Serializer
  attributes :id,
             :product_variant_name,
             :product_variant_sku,
             :product_variant_image,
             :product_variant_price,
             :product_variant_id,
             :stripe_price_id,
             :quantity

  def stripe_price_id
    object&.product_variant&.stripe_price_id
  end
  def product_variant_name
    object&.product_variant&.name
  end
  def product_variant_sku
    object&.product_variant&.sku
  end

  def product_variant_price
    object&.product_variant&.price
  end

  def product_variant_image
    object&.product_variant&.product&.product_images[0]&.url
  end
end
