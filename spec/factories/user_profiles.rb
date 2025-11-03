FactoryBot.define do
  factory :user_profile do
    full_name { Faker::Name.name }
    phone { "0901234567" }
    avatar_url { "dummy-file.jpg" }
    locale { "en" }
    time_zone { "Asia/Ho_Chi_Minh" }
  end
end
