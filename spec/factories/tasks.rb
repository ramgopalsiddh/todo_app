FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
  end

  factory :task do
    title { "Test Task" }
    description { "This is a test task" }
    due_date { "2024-12-31" }
    completed { false }
  end
end
