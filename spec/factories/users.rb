# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    association :organization
    email { Faker::Internet.email }
    password { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { 'user' }

    trait :admin do
      role { 'admin' }
    end

    trait :with_oauth do
      provider { 'google_oauth2' }
      uid { SecureRandom.uuid }
    end
  end
end