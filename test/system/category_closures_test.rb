require "application_system_test_case"

class CategoryClosuresTest < ApplicationSystemTestCase
  setup do
    @category_closure = category_closures(:one)
  end

  test "visiting the index" do
    visit category_closures_url
    assert_selector "h1", text: "Category closures"
  end

  test "should create category closure" do
    visit category_closures_url
    click_on "New category closure"

    click_on "Create Category closure"

    assert_text "Category closure was successfully created"
    click_on "Back"
  end

  test "should update Category closure" do
    visit category_closure_url(@category_closure)
    click_on "Edit this category closure", match: :first

    click_on "Update Category closure"

    assert_text "Category closure was successfully updated"
    click_on "Back"
  end

  test "should destroy Category closure" do
    visit category_closure_url(@category_closure)
    click_on "Destroy this category closure", match: :first

    assert_text "Category closure was successfully destroyed"
  end
end
