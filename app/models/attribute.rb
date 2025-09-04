class Attribute < ApplicationRecord
  acts_as_paranoid
  has_many :attribute_values, dependent: :destroy
  accepts_nested_attributes_for :attribute_values, allow_destroy: true
end
