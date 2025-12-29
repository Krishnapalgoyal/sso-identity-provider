# spec/models/service_provider_spec.rb
require 'rails_helper'

RSpec.describe ServiceProvider, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:entity_id) }
    it { should validate_presence_of(:acs_url) }
  end

  describe 'scopes' do
    let(:organization) { create(:organization) }
    
    before do
      ActsAsTenant.current_tenant = organization
    end
    
    it 'returns only active service providers' do
      active_sp = create(:service_provider, active: true)
      inactive_sp = create(:service_provider, :inactive)
      
      expect(ServiceProvider.active).to include(active_sp)
      expect(ServiceProvider.active).not_to include(inactive_sp)
    end
  end
end