require "test_helper"

class AttributeValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attribute_value = attribute_values(:one)
  end

  test "should get index" do
    get attribute_values_url
    assert_response :success
  end

  test "should get new" do
    get new_attribute_value_url
    assert_response :success
  end

  test "should create attribute_value" do
    assert_difference("AttributeValue.count") do
      post attribute_values_url, params: { attribute_value: {} }
    end

    assert_redirected_to attribute_value_url(AttributeValue.last)
  end

  test "should show attribute_value" do
    get attribute_value_url(@attribute_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_attribute_value_url(@attribute_value)
    assert_response :success
  end

  test "should update attribute_value" do
    patch attribute_value_url(@attribute_value), params: { attribute_value: {} }
    assert_redirected_to attribute_value_url(@attribute_value)
  end

  test "should destroy attribute_value" do
    assert_difference("AttributeValue.count", -1) do
      delete attribute_value_url(@attribute_value)
    end

    assert_redirected_to attribute_values_url
  end
end
