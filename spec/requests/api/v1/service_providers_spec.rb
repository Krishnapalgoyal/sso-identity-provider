# spec/requests/api/v1/service_providers_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::ServiceProviders', type: :request do
  let(:organization) { create(:organization) }
  let(:headers) do
    {
      'X-API-Key' => organization.api_key,
      'X-API-Secret' => organization.api_secret_digest,
      'Content-Type' => 'application/json'
    }
  end

  before do
    ActsAsTenant.current_tenant = organization
  end

  describe 'GET /api/v1/service_providers' do
    it 'returns all service providers' do
      create_list(:service_provider, 3, organization: organization)
      
      get '/api/v1/service_providers', headers: headers
      
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'returns unauthorized without API key' do
      get '/api/v1/service_providers'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/service_providers' do
    it 'creates a new service provider' do
      sp_params = {
        service_provider: {
          name: 'Test SP',
          entity_id: 'https://test.com',
          acs_url: 'https://test.com/saml/acs'
        }
      }
      
      post '/api/v1/service_providers', params: sp_params.to_json, headers: headers
      
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('Test SP')
    end
  end
end