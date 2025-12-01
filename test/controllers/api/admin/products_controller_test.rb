require "test_helper"

class Api::Admin::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @product = products(:iphone)
    @deleted_product = products(:deleted_product)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_products_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
    assert json["data"]["products"].present?
  end

  test "should not get index when not authenticated" do
    get api_admin_products_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_products_url
    assert_response :forbidden
  end

  test "should show product when authenticated as admin" do
    sign_in @admin
    get api_admin_product_url(@product)
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
    assert json["data"]["product"].present?
  end

  test "should show deleted product when authenticated as admin" do
    sign_in @admin
    get api_admin_product_url(@deleted_product)
    assert_response :success
  end

  test "should update product when authenticated as admin" do
    sign_in @admin
    patch api_admin_product_url(@product), params: {
      product: {
        name: @product.name,
        slug: @product.slug,
        description: "Updated description"
      }
    }
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "should destroy product when authenticated as admin" do
    sign_in @admin
    product = Product.create!(name: "To Delete", slug: "to-delete")
    delete api_admin_product_url(product)
    assert_response :success
    assert product.reload.deleted?
  end

  test "should restore product when authenticated as admin" do
    sign_in @admin
    product = Product.create!(name: "To Restore", slug: "to-restore")
    product.destroy
    post restore_api_admin_product_url(product)
    assert_response :success
    assert_not product.reload.deleted?
  end

  test "index should support pagination" do
    sign_in @admin
    get api_admin_products_url, params: { page: 1, per_page: 2 }
    assert_response :success
    json = response.parsed_body
    assert json["meta"].present?
  end

  test "index includes deleted products" do
    sign_in @admin
    get api_admin_products_url
    assert_response :success
    json = response.parsed_body
    product_ids = json["data"]["products"].map { |p| p["id"] }
    assert_includes product_ids, @deleted_product.id
  end
end

