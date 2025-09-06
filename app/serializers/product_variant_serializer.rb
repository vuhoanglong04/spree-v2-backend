class ProductVariantSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :sku,
             :name,
             :origin_price,
             :price,
             :stock_qty,
             :stripe_product_id,
             :stripe_price_id,
             :deleted_at,
             :created_at,
             :updated_at
  has_many :attribute_values
end
