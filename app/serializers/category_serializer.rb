class CategorySerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id, :name, :slug, :position, :parent_id, :created_at, :updated_at
end
