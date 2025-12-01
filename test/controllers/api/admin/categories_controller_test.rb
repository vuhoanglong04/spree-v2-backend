require "test_helper"

class Api::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @category = categories(:electronics)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_categories_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
    assert json["data"]["categories"].present?
  end

  test "should not get index when not authenticated" do
    get api_admin_categories_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_categories_url
    assert_response :forbidden
  end

  test "should create category when authenticated as admin" do
    sign_in @admin
    assert_difference("Category.count") do
      post api_admin_categories_url, params: {
        name: "New Category",
        slug: "new-category",
        position: 1
      }
    end
    assert_response :created
    json = response.parsed_body
    assert_equal "success", json["status"]
    assert_equal "Create a category successfully", json["message"]
  end

  test "should not create category with duplicate name" do
    sign_in @admin
    assert_no_difference("Category.count") do
      post api_admin_categories_url, params: {
        name: @category.name,
        slug: "unique-slug",
        position: 1
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update category when authenticated as admin" do
    sign_in @admin
    patch api_admin_category_url(@category), params: {
      name: "Updated Electronics",
      slug: @category.slug
    }
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "should destroy category when authenticated as admin" do
    sign_in @admin
    category = Category.create!(name: "To Delete", slug: "to-delete")
    delete api_admin_category_url(category)
    assert_response :success
    assert category.reload.deleted?
  end

  test "should restore category when authenticated as admin" do
    sign_in @admin
    category = Category.create!(name: "To Restore", slug: "to-restore")
    category.destroy
    post restore_api_admin_category_url(category)
    assert_response :success
    assert_not category.reload.deleted?
  end

  test "should search categories" do
    sign_in @admin
    get api_admin_categories_search_list_url, params: { name: "Elec" }
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "index should support pagination" do
    sign_in @admin
    get api_admin_categories_url, params: { page: 1, per_page: 2 }
    assert_response :success
    json = response.parsed_body
    assert json["meta"].present?
    assert json["meta"]["current_page"].present?
  end
end

