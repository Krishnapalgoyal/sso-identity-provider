# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_current_tenant
  
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
end