# spec/controllers/saml_controller_spec.rb
require 'rails_helper'

RSpec.describe SamlController, type: :controller do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organization: organization) }
  let(:service_provider) { create(:service_provider, organization: organization) }

  before do
    ActsAsTenant.current_tenant = organization
    sign_in user
  end

  describe 'GET #metadata' do
    it 'returns SAML metadata XML' do
      get :metadata
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/xml')
      expect(response.body).to include('EntityDescriptor')
    end
  end

  describe 'POST #auth' do
    it 'generates SAML response for valid SP' do
      post :auth, params: { sp_entity_id: service_provider.entity_id }
      
      expect(response).to have_http_status(:success)
      expect(response.body).to include('SAMLResponse')
      expect(response.body).to include(service_provider.acs_url)
    end

    it 'rejects invalid SP' do
      post :auth, params: { sp_entity_id: 'invalid' }
      
      expect(response).to have_http_status(:forbidden)
    end
  end
end