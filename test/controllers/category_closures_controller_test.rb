require "test_helper"

class CategoryClosuresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category_closure = category_closures(:one)
  end

  test "should get index" do
    get category_closures_url
    assert_response :success
  end

  test "should get new" do
    get new_category_closure_url
    assert_response :success
  end

  test "should create category_closure" do
    assert_difference("CategoryClosure.count") do
      post category_closures_url, params: { category_closure: {} }
    end

    assert_redirected_to category_closure_url(CategoryClosure.last)
  end

  test "should show category_closure" do
    get category_closure_url(@category_closure)
    assert_response :success
  end

  test "should get edit" do
    get edit_category_closure_url(@category_closure)
    assert_response :success
  end

  test "should update category_closure" do
    patch category_closure_url(@category_closure), params: { category_closure: {} }
    assert_redirected_to category_closure_url(@category_closure)
  end

  test "should destroy category_closure" do
    assert_difference("CategoryClosure.count", -1) do
      delete category_closure_url(@category_closure)
    end

    assert_redirected_to category_closures_url
  end
end
