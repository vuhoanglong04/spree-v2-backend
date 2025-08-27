class AccountUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :status
end
