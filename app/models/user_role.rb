class UserRole < ApplicationRecord
  # Relationship
  belongs_to :account_user
  belongs_to :role
end
