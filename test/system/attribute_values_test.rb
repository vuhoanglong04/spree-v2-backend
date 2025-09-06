require "application_system_test_case"

class AttributeValuesTest < ApplicationSystemTestCase
  setup do
    @attribute_value = attribute_values(:one)
  end

  test "visiting the index" do
    visit attribute_values_url
    assert_selector "h1", text: "ProductAttribute values"
  end

  test "should create attribute value" do
    visit attribute_values_url
    click_on "New attribute value"

    click_on "Create ProductAttribute value"

    assert_text "ProductAttribute value was successfully created"
    click_on "Back"
  end

  test "should update ProductAttribute value" do
    visit attribute_value_url(@attribute_value)
    click_on "Edit this attribute value", match: :first

    click_on "Update ProductAttribute value"

    assert_text "ProductAttribute value was successfully updated"
    click_on "Back"
  end

  test "should destroy ProductAttribute value" do
    visit attribute_value_url(@attribute_value)
    click_on "Destroy this attribute value", match: :first

    assert_text "ProductAttribute value was successfully destroyed"
  end
end
