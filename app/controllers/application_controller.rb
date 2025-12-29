# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_current_tenant
  after_action :log_user_activity, if: :user_signed_in?
  
  private
  
  def set_current_tenant
    subdomain = request.subdomain
    
    if subdomain.present? && subdomain != 'www'
      organization = Organization.find_by(subdomain: subdomain)
      ActsAsTenant.current_tenant = organization if organization
    end
  end
  
  def current_organization
    ActsAsTenant.current_tenant
  end
  helper_method :current_organization
  
  def log_user_activity
    return unless current_organization && current_user
    
    AuditLog.log_action(
      "#{controller_name}##{action_name}",
      user: current_user,
      metadata: {
        controller: controller_name,
        action: action_name,
        params: filtered_params
      },
      ip: request.remote_ip
    )
  rescue => e
    Rails.logger.error "Failed to log audit: #{e.message}"
  end
  
  def filtered_params
    request.params.except(:controller, :action, :password, :password_confirmation)
  end
end