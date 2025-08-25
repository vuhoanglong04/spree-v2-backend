require "test_helper"

class ProductVariantAttrValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_variant_attr_value = product_variant_attr_values(:one)
  end

  test "should get index" do
    get product_variant_attr_values_url
    assert_response :success
  end

  test "should get new" do
    get new_product_variant_attr_value_url
    assert_response :success
  end

  test "should create product_variant_attr_value" do
    assert_difference("ProductVariantAttrValue.count") do
      post product_variant_attr_values_url, params: { product_variant_attr_value: {} }
    end

    assert_redirected_to product_variant_attr_value_url(ProductVariantAttrValue.last)
  end

  test "should show product_variant_attr_value" do
    get product_variant_attr_value_url(@product_variant_attr_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_variant_attr_value_url(@product_variant_attr_value)
    assert_response :success
  end

  test "should update product_variant_attr_value" do
    patch product_variant_attr_value_url(@product_variant_attr_value), params: { product_variant_attr_value: {} }
    assert_redirected_to product_variant_attr_value_url(@product_variant_attr_value)
  end

  test "should destroy product_variant_attr_value" do
    assert_difference("ProductVariantAttrValue.count", -1) do
      delete product_variant_attr_value_url(@product_variant_attr_value)
    end

    assert_redirected_to product_variant_attr_values_url
  end
end
