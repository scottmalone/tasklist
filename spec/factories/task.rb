FactoryBot.define do
  factory :task, class: Task do
    association :user
    due { Date.today }
    description { "Need to code" }

    trait :with_attachment do
      after(:build) do |t|
        t.attachments.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_file.jpeg')), filename: 'test_file.jpeg', content_type: 'image/jpeg')
      end
    end

    trait :with_attachments do
      after(:build) do |t|
        t.attachments.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_file.jpeg')), filename: 'test_file1.jpeg', content_type: 'image/jpeg')
        t.attachments.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_file.jpeg')), filename: 'test_file2.jpeg', content_type: 'image/jpeg')
      end
    end
  end
end
