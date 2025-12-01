require "test_helper"

class ProductAttributeTest < ActiveSupport::TestCase
  test "product_attribute has many attribute_values" do
    attr = product_attributes(:color)
    assert_respond_to attr, :attribute_values
    assert attr.attribute_values.any?
  end

  test "destroying product_attribute destroys attribute_values" do
    attr = ProductAttribute.create(name: "Temp Attr", slug: "temp-attr")
    AttributeValue.create(product_attribute: attr, value: "Temp Value")

    attr_id = attr.id
    attr.destroy

    assert_empty AttributeValue.where(product_attribute_id: attr_id)
  end

  test "product_attribute supports soft delete" do
    attr = ProductAttribute.create(name: "Soft Delete Attr", slug: "soft-delete-attr")
    assert_not attr.deleted?
    attr.destroy
    assert attr.deleted?
  end

  test "product_attribute accepts nested attributes for attribute_values" do
    attr = ProductAttribute.new(
      name: "Nested Attr",
      slug: "nested-attr",
      attribute_values_attributes: [
        { value: "Value 1" },
        { value: "Value 2" }
      ]
    )
    assert attr.save
    assert_equal 2, attr.attribute_values.count
  end
end

