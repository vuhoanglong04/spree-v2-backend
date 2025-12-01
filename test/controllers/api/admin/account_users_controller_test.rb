require "test_helper"

class Api::Admin::AccountUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_account_users_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "should not get index when not authenticated" do
    get api_admin_account_users_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_account_users_url
    assert_response :forbidden
  end

  test "should show account_user when authenticated as admin" do
    sign_in @admin
    get api_admin_account_user_url(@customer)
    assert_response :success
  end

  test "should get user role when authenticated as admin" do
    sign_in @admin
    get role_api_admin_account_user_url(@admin)
    assert_response :success
  end

  test "should update account_user when authenticated as admin" do
    sign_in @admin
    patch api_admin_account_user_url(@customer), params: {
      account_user: {
        status: "disabled"
      }
    }
    assert_response :success
  end
end

