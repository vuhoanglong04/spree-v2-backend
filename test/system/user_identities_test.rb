require "application_system_test_case"

class UserIdentitiesTest < ApplicationSystemTestCase
  setup do
    @user_identity = user_identities(:one)
  end

  test "visiting the index" do
    visit user_identities_url
    assert_selector "h1", text: "User identities"
  end

  test "should create user identity" do
    visit user_identities_url
    click_on "New user identity"

    click_on "Create User identity"

    assert_text "User identity was successfully created"
    click_on "Back"
  end

  test "should update User identity" do
    visit user_identity_url(@user_identity)
    click_on "Edit this user identity", match: :first

    click_on "Update User identity"

    assert_text "User identity was successfully updated"
    click_on "Back"
  end

  test "should destroy User identity" do
    visit user_identity_url(@user_identity)
    click_on "Destroy this user identity", match: :first

    assert_text "User identity was successfully destroyed"
  end
end
