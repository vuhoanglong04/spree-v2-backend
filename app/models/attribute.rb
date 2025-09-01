class Attribute < ApplicationRecord
  has_many :attribute_values, dependent: :destroy
end
