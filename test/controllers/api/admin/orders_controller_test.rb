require "test_helper"

class Api::Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @pending_order = orders(:pending_order)
    @paid_order = orders(:paid_order)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_orders_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
    assert json["data"]["orders"].present?
  end

  test "should not get index when not authenticated" do
    get api_admin_orders_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_orders_url
    assert_response :forbidden
  end

  test "should update order status when authenticated as admin" do
    sign_in @admin
    patch api_admin_order_url(@pending_order), params: {
      status: "paid"
    }
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "index should support pagination" do
    sign_in @admin
    get api_admin_orders_url, params: { page: 1, per_page: 2 }
    assert_response :success
    json = response.parsed_body
    assert json["meta"].present?
    assert json["meta"]["current_page"].present?
  end

  test "orders are sorted by updated_at desc" do
    sign_in @admin
    get api_admin_orders_url
    assert_response :success
    json = response.parsed_body
    orders = json["data"]["orders"]
    if orders.length > 1
      timestamps = orders.map { |o| o["updated_at"] }
      assert_equal timestamps, timestamps.sort.reverse
    end
  end
end

