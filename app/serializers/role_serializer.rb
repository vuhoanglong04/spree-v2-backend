class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :permissions, serializer: PermissionSerializer
end
