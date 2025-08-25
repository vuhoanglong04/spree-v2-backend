require "application_system_test_case"

class ProductVariantAttrValuesTest < ApplicationSystemTestCase
  setup do
    @product_variant_attr_value = product_variant_attr_values(:one)
  end

  test "visiting the index" do
    visit product_variant_attr_values_url
    assert_selector "h1", text: "Product variant attr values"
  end

  test "should create product variant attr value" do
    visit product_variant_attr_values_url
    click_on "New product variant attr value"

    click_on "Create Product variant attr value"

    assert_text "Product variant attr value was successfully created"
    click_on "Back"
  end

  test "should update Product variant attr value" do
    visit product_variant_attr_value_url(@product_variant_attr_value)
    click_on "Edit this product variant attr value", match: :first

    click_on "Update Product variant attr value"

    assert_text "Product variant attr value was successfully updated"
    click_on "Back"
  end

  test "should destroy Product variant attr value" do
    visit product_variant_attr_value_url(@product_variant_attr_value)
    click_on "Destroy this product variant attr value", match: :first

    assert_text "Product variant attr value was successfully destroyed"
  end
end
