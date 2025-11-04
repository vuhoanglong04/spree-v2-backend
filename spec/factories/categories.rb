FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Electronics #{n}" }
    sequence(:slug) { |n| "electronics-#{n}" }
    position { 0 }

    trait :with_children do
      after(:create) do |category|
        create(:category, parent: category, name: "Laptops #{SecureRandom.hex(2)}", slug: "laptops-#{SecureRandom.hex(2)}")
        create(:category, parent: category, name: "Phones #{SecureRandom.hex(2)}", slug: "phones-#{SecureRandom.hex(2)}")
      end
    end

    trait :with_parent do
      association :parent, factory: :category, name: "Parent Category #{SecureRandom.hex(2)}", slug: "parent-category-#{SecureRandom.hex(2)}"
    end
  end
end

