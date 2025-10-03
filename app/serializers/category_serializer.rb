class CategorySerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :name,
             :slug,
             :product_count,
             :position,
             :deleted_at,
             :created_at,
             :updated_at

  def product_count
    object.products.count
  end
end

