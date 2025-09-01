class UserProfile < ApplicationRecord
  # Relationship
  belongs_to :account_user
end
