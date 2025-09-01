class AttributeValue < ApplicationRecord
  belongs_to :product_attribute, class_name: "Attribute", foreign_key: "attribute_id"
end
