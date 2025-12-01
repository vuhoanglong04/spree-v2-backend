require "test_helper"

class Api::Admin::PromotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = account_users(:admin_user)
    @customer = account_users(:customer_user)
    @promotion = promotions(:summer_sale)
  end

  test "should get index when authenticated as admin" do
    sign_in @admin
    get api_admin_promotions_url
    assert_response :success
    json = response.parsed_body
    assert_equal "success", json["status"]
  end

  test "should not get index when not authenticated" do
    get api_admin_promotions_url
    assert_response :unauthorized
  end

  test "should not get index when authenticated as customer" do
    sign_in @customer
    get api_admin_promotions_url
    assert_response :forbidden
  end

  test "should show promotion when authenticated as admin" do
    sign_in @admin
    get api_admin_promotion_url(@promotion)
    assert_response :success
  end

  test "should create promotion when authenticated as admin" do
    sign_in @admin
    assert_difference("Promotion.count") do
      post api_admin_promotions_url, params: {
        promotion: {
          code: "NEWPROMO2025",
          promotion_type: "percentage",
          value: 20,
          start_date: Time.current,
          end_date: 1.month.from_now,
          description: "New promotion"
        }
      }
    end
    assert_response :success
  end

  test "should not create promotion with invalid data" do
    sign_in @admin
    assert_no_difference("Promotion.count") do
      post api_admin_promotions_url, params: {
        promotion: {
          code: "",
          promotion_type: "percentage",
          value: 20,
          start_date: Time.current,
          end_date: 1.month.from_now
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should update promotion when authenticated as admin" do
    sign_in @admin
    patch api_admin_promotion_url(@promotion), params: {
      promotion: {
        description: "Updated summer sale"
      }
    }
    assert_response :success
  end

  test "should destroy promotion when authenticated as admin" do
    sign_in @admin
    promotion = Promotion.create!(
      code: "TODELETE",
      promotion_type: :percentage,
      value: 10,
      start_date: Time.current,
      end_date: 1.week.from_now
    )
    delete api_admin_promotion_url(promotion)
    assert_response :success
    assert promotion.reload.deleted?
  end

  test "should restore promotion when authenticated as admin" do
    sign_in @admin
    promotion = Promotion.create!(
      code: "TORESTORE",
      promotion_type: :percentage,
      value: 10,
      start_date: Time.current,
      end_date: 1.week.from_now
    )
    promotion.destroy
    post restore_api_admin_promotion_url(promotion)
    assert_response :success
    assert_not promotion.reload.deleted?
  end
end

