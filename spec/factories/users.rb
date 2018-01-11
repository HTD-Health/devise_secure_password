FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@email.com" }
    password 'Password1!'
  end
end
