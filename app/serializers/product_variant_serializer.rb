class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id,
             :sku,
             :name,
             :origin_price,
             :price,
             :stock_qty,
             :stripe_product_id,
             :stripe_price_id

end
