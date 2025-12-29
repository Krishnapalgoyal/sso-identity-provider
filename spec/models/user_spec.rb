# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should have_many(:audit_logs).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_inclusion_of(:role).in_array(%w[user admin super_admin]) }
  end

  describe '#admin?' do
    it 'returns true for admin role' do
      user = build(:user, role: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false for user role' do
      user = build(:user, role: 'user')
      expect(user.admin?).to be false
    end
  end

  describe '#full_name' do
    it 'returns first and last name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end

    it 'returns email if name is blank' do
      user = build(:user, first_name: nil, last_name: nil, email: 'test@example.com')
      expect(user.full_name).to eq('test@example.com')
    end
  end
end