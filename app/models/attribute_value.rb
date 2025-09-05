class AttributeValue < ApplicationRecord
  belongs_to :product_attribute, foreign_key: :product_attribute_id
end
