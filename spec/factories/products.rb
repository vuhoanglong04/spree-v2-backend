FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    slug { "product-#{SecureRandom.uuid}" }
    description { "Product description" }
    brand { "Test Brand" }
    total_sold { 0 }
    favourite_count { 0 }
  end
end

