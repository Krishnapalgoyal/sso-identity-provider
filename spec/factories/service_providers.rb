# spec/factories/service_providers.rb
FactoryBot.define do
  factory :service_provider do
    association :organization
    name { Faker::Company.name }
    entity_id { "https://#{Faker::Internet.domain_name}" }
    acs_url { "https://#{Faker::Internet.domain_name}/saml/acs" }
    active { true }
    
    trait :inactive do
      active { false }
    end
  end
end