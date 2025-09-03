class UserRoleSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id, :account_user_id, :role_id, :created_at, :updated_at
end
