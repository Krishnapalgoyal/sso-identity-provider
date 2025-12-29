# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_request!
      before_action :set_current_tenant
      
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from ActsAsTenant::Errors::NoTenantSet, with: :no_tenant
      
      private
      
      def authenticate_api_request!
        api_key = request.headers['X-API-Key']
        api_secret = request.headers['X-API-Secret']
        
        unless api_key.present? && api_secret.present?
          render json: { error: 'Missing API credentials' }, status: :unauthorized
          return
        end
        
        @current_organization = Organization.find_by(api_key: api_key)
        
        unless @current_organization&.verify_api_secret(api_secret)
          render json: { error: 'Invalid API credentials' }, status: :unauthorized
          return
        end
        
        unless @current_organization.active?
          render json: { error: 'Organization is inactive' }, status: :forbidden
          return
        end
      end
      
      def set_current_tenant
        ActsAsTenant.current_tenant = @current_organization if @current_organization
      end
      
      def current_organization
        @current_organization
      end
      
      def not_found
        render json: { error: 'Record not found' }, status: :not_found
      end
      
      def unprocessable_entity(exception)
        render json: { 
          error: 'Validation failed', 
          details: exception.record.errors.full_messages 
        }, status: :unprocessable_entity
      end
      
      def no_tenant
        render json: { error: 'No tenant set' }, status: :bad_request
      end
    end
  end
end