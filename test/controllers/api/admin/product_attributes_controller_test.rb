require "test_helper"

class Api::Admin::ProductAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @product_attribute = product_attributes(:color)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_product_attributes_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "should not get index when not authenticated" do
    get api_admin_product_attributes_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_product_attributes_url
    assert_response :forbidden
  end

  test "should show product_attribute when authenticated as admin" do
    sign_in @admin
    get api_admin_product_attribute_url(@product_attribute)
    assert_response :success
  end

  test "should create product_attribute when authenticated as admin" do
    sign_in @admin
    assert_difference("ProductAttribute.count") do
      post api_admin_product_attributes_url, params: {
        product_attribute: {
          name: "Material",
          slug: "material",
          description: "Product material"
        }
      }
    end
    assert_response :success
  end

  test "should update product_attribute when authenticated as admin" do
    sign_in @admin
    patch api_admin_product_attribute_url(@product_attribute), params: {
      product_attribute: {
        description: "Updated color description"
      }
    }
    assert_response :success
  end

  test "should destroy product_attribute when authenticated as admin" do
    sign_in @admin
    attr = ProductAttribute.create!(name: "To Delete", slug: "to-delete")
    delete api_admin_product_attribute_url(attr)
    assert_response :success
    assert attr.reload.deleted?
  end

  test "should restore product_attribute when authenticated as admin" do
    sign_in @admin
    attr = ProductAttribute.create!(name: "To Restore", slug: "to-restore")
    attr.destroy
    post restore_api_admin_product_attribute_url(attr)
    assert_response :success
    assert_not attr.reload.deleted?
  end
end

