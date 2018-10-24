FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }
    password { "gogoreddot" }
    password_confirmation { "gogoreddot" }
  end
end
