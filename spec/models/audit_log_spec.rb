# spec/models/audit_log_spec.rb
require 'rails_helper'

RSpec.describe AuditLog, type: :model do
  describe 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:action) }
  end

  describe '.log_action' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user, organization: organization) }
    
    before do
      ActsAsTenant.current_tenant = organization
    end
    
    it 'creates an audit log entry' do
      expect {
        AuditLog.log_action(
          'login',
          user: user,
          metadata: { browser: 'Chrome' },
          ip: '127.0.0.1'
        )
      }.to change(AuditLog, :count).by(1)
    end
  end
end