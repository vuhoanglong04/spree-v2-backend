class ProductSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :name,
             :slug,
             :description,
             :total_sold,
             :brand,
             :favourite_count,
             :deleted_at,
             :created_at,
             :updated_at
  has_many :categories
  has_many :product_images
  has_many :product_variants, serializer: ProductVariantSerializer
end
