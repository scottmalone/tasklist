FactoryBot.define do
  factory :task, class: Task do
    association :user
    due { Date.today }
    description { "Need to code" }
  end
end
