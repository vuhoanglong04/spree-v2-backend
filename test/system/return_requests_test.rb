require "application_system_test_case"

class ReturnRequestsTest < ApplicationSystemTestCase
  setup do
    @return_request = return_requests(:one)
  end

  test "visiting the index" do
    visit return_requests_url
    assert_selector "h1", text: "Return requests"
  end

  test "should create return request" do
    visit return_requests_url
    click_on "New return request"

    click_on "Create Return request"

    assert_text "Return request was successfully created"
    click_on "Back"
  end

  test "should update Return request" do
    visit return_request_url(@return_request)
    click_on "Edit this return request", match: :first

    click_on "Update Return request"

    assert_text "Return request was successfully updated"
    click_on "Back"
  end

  test "should destroy Return request" do
    visit return_request_url(@return_request)
    click_on "Destroy this return request", match: :first

    assert_text "Return request was successfully destroyed"
  end
end
