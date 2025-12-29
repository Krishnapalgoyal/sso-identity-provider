# spec/factories/audit_logs.rb
FactoryBot.define do
  factory :audit_log do
    association :organization
    association :user
    action { ['create', 'update', 'delete', 'login', 'logout'].sample }
    resource_type { 'User' }
    resource_id { 1 }
    metadata { { details: 'Test action' } }
    ip_address { Faker::Internet.ip_v4_address }
  end
end