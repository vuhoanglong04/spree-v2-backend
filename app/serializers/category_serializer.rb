class CategorySerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :name,
             :slug,
             :product_count,
             :position,
             :parent_id,
             :parent_name,
             :deleted_at,
             :created_at,
             :updated_at

  def product_count
    object.products.count
  end

  def parent_name
    object&.categories&.name
  end

end

