require "application_system_test_case"

class RefundsTest < ApplicationSystemTestCase
  setup do
    @refund = refunds(:one)
  end

  test "visiting the index" do
    visit refunds_url
    assert_selector "h1", text: "Refunds"
  end

  test "should create refund" do
    visit refunds_url
    click_on "New refund"

    click_on "Create Refund"

    assert_text "Refund was successfully created"
    click_on "Back"
  end

  test "should update Refund" do
    visit refund_url(@refund)
    click_on "Edit this refund", match: :first

    click_on "Update Refund"

    assert_text "Refund was successfully updated"
    click_on "Back"
  end

  test "should destroy Refund" do
    visit refund_url(@refund)
    click_on "Destroy this refund", match: :first

    assert_text "Refund was successfully destroyed"
  end
end
