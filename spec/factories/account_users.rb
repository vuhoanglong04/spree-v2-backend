FactoryBot.define do
  factory :account_user do
    main_role { "admin" }
    email { Faker::Internet.email }
    status { "active" }
    password { "password123" }
    password_confirmation { "password123" }

    association :user_profile
  end
end
