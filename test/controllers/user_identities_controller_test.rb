require "test_helper"

class UserIdentitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_identity = user_identities(:one)
  end

  test "should get index" do
    get user_identities_url
    assert_response :success
  end

  test "should get new" do
    get new_user_identity_url
    assert_response :success
  end

  test "should create user_identity" do
    assert_difference("UserIdentity.count") do
      post user_identities_url, params: { user_identity: {} }
    end

    assert_redirected_to user_identity_url(UserIdentity.last)
  end

  test "should show user_identity" do
    get user_identity_url(@user_identity)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_identity_url(@user_identity)
    assert_response :success
  end

  test "should update user_identity" do
    patch user_identity_url(@user_identity), params: { user_identity: {} }
    assert_redirected_to user_identity_url(@user_identity)
  end

  test "should destroy user_identity" do
    assert_difference("UserIdentity.count", -1) do
      delete user_identity_url(@user_identity)
    end

    assert_redirected_to user_identities_url
  end
end
