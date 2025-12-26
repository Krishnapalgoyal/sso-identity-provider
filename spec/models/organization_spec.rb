require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    subject { build(:organization) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain).case_insensitive }
    it { should validate_uniqueness_of(:api_key) }
  end

  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'generates api credentials before create' do
      org = Organization.create!(name: 'Test Org', subdomain: 'test')
      
      expect(org.api_key).to be_present
      expect(org.api_key.length).to eq(64)
      expect(org.api_secret_digest).to be_present
    end

    it 'normalizes subdomain' do
      org = Organization.create!(name: 'Test', subdomain: 'Test-ORG')
      expect(org.subdomain).to eq('test-org')
    end
  end

  describe '#regenerate_api_key!' do
    it 'generates new api key' do
      org = create(:organization)
      old_key = org.api_key
      
      org.regenerate_api_key!
      
      expect(org.api_key).not_to eq(old_key)
    end
  end
end