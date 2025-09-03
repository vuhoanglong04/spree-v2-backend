class UserRole < ApplicationRecord
  # Relationship
  belongs_to :account_user
  belongs_to :role
  # Validations
  validates :account_user_id, :role_id, presence: true
end
