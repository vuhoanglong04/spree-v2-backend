class ProductVariant < ApplicationRecord
  belongs_to :product
  acts_as_paranoid
end
