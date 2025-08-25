require "application_system_test_case"

class AttributeValuesTest < ApplicationSystemTestCase
  setup do
    @attribute_value = attribute_values(:one)
  end

  test "visiting the index" do
    visit attribute_values_url
    assert_selector "h1", text: "Attribute values"
  end

  test "should create attribute value" do
    visit attribute_values_url
    click_on "New attribute value"

    click_on "Create Attribute value"

    assert_text "Attribute value was successfully created"
    click_on "Back"
  end

  test "should update Attribute value" do
    visit attribute_value_url(@attribute_value)
    click_on "Edit this attribute value", match: :first

    click_on "Update Attribute value"

    assert_text "Attribute value was successfully updated"
    click_on "Back"
  end

  test "should destroy Attribute value" do
    visit attribute_value_url(@attribute_value)
    click_on "Destroy this attribute value", match: :first

    assert_text "Attribute value was successfully destroyed"
  end
end
