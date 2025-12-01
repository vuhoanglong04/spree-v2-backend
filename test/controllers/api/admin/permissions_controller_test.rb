require "test_helper"

class Api::Admin::PermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @permission = permissions(:read_products)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_permissions_url
    assert_response :success
  end

  test "should not get index when not authenticated" do
    get api_admin_permissions_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_permissions_url
    assert_response :forbidden
  end

  test "should show permission when authenticated as admin" do
    sign_in @admin
    get api_admin_permission_url(@permission)
    assert_response :success
  end

  test "should create permission when authenticated as admin" do
    sign_in @admin
    assert_difference("Permission.count") do
      post api_admin_permissions_url, params: {
        permission: {
          action_name: "archive",
          subject: "Product",
          description: "Can archive products"
        }
      }
    end
    assert_response :success
  end

  test "should update permission when authenticated as admin" do
    sign_in @admin
    patch api_admin_permission_url(@permission), params: {
      permission: {
        description: "Updated description"
      }
    }
    assert_response :success
  end

  test "should destroy permission when authenticated as admin" do
    sign_in @admin
    permission = Permission.create!(action_name: "test_delete", subject: "TestSubject")
    assert_difference("Permission.count", -1) do
      delete api_admin_permission_url(permission)
    end
    assert_response :success
  end
end

