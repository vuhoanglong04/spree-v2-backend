require "test_helper"

class Api::Admin::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @role = roles(:admin_role)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_roles_url
    assert_response :success
  end

  test "should not get index when not authenticated" do
    get api_admin_roles_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_roles_url
    assert_response :forbidden
  end

  test "should show role when authenticated as admin" do
    sign_in @admin
    get api_admin_role_url(@role)
    assert_response :success
  end

  test "should create role when authenticated as admin" do
    sign_in @admin
    assert_difference("Role.count") do
      post api_admin_roles_url, params: {
        role: {
          name: "New Role",
          description: "A new test role"
        }
      }
    end
    assert_response :success
  end

  test "should update role when authenticated as admin" do
    sign_in @admin
    patch api_admin_role_url(@role), params: {
      role: {
        description: "Updated description"
      }
    }
    assert_response :success
  end

  test "should destroy role when authenticated as admin" do
    sign_in @admin
    role = Role.create!(name: "To Delete Role")
    assert_difference("Role.count", -1) do
      delete api_admin_role_url(role)
    end
    assert_response :success
  end
end

