class AccountUserSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id, :email, :status, :created_at, :updated_at
  attribute :confirmed_at, if: -> { object.confirmed_at.present? }
  has_many :user_identities
  has_one :user_profile
end
