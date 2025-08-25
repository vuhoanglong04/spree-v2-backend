require "application_system_test_case"

class AttributesTest < ApplicationSystemTestCase
  setup do
    @attribute = attributes(:one)
  end

  test "visiting the index" do
    visit attributes_url
    assert_selector "h1", text: "Attributes"
  end

  test "should create attribute" do
    visit attributes_url
    click_on "New attribute"

    click_on "Create Attribute"

    assert_text "Attribute was successfully created"
    click_on "Back"
  end

  test "should update Attribute" do
    visit attribute_url(@attribute)
    click_on "Edit this attribute", match: :first

    click_on "Update Attribute"

    assert_text "Attribute was successfully updated"
    click_on "Back"
  end

  test "should destroy Attribute" do
    visit attribute_url(@attribute)
    click_on "Destroy this attribute", match: :first

    assert_text "Attribute was successfully destroyed"
  end
end
