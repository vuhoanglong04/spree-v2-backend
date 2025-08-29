class AccountUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :status, :confirmed_at, :created_at, :updated_at
  has_many :user_identities
  has_one :user_profile
end
