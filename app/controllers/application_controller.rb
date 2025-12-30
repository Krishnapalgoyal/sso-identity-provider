# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :set_current_tenant
  before_action :ensure_tenant!, unless: :devise_controller?
  before_action :block_signup_on_subdomain, if: :devise_registration_action?
  after_action  :log_user_activity, if: :user_signed_in?

  helper_method :current_organization

  private

  # ----------------------------------------------------
  # Tenant handling
  # ----------------------------------------------------
  def set_current_tenant
    return if ActsAsTenant.current_tenant.present?

    # 1️⃣ Prefer subdomain
    subdomain = request.subdomain
    if subdomain.present? && subdomain != "www"
      organization = Organization.find_by(subdomain: subdomain)
      ActsAsTenant.current_tenant = organization if organization
    end

    # 2️⃣ Fallback to user's organization (IMPORTANT)
    if user_signed_in? && ActsAsTenant.current_tenant.blank?
      ActsAsTenant.current_tenant = current_user.organization
    end
  end

  def current_organization
    ActsAsTenant.current_tenant
  end

  def ensure_tenant!
    return unless user_signed_in?
    return if current_organization.present?

    sign_out current_user

    redirect_to root_url(subdomain: nil),
      alert: "Organization not found. Please login again."
  end

  # ----------------------------------------------------
  # Signup blocking
  # ----------------------------------------------------
  def block_signup_on_subdomain
    redirect_to root_url(subdomain: nil),
      alert: "Signup must be done on the main domain"
  end

  def devise_registration_action?
    controller_name == "registrations" &&
      %w[new create].include?(action_name) &&
      request.subdomain.present? &&
      request.subdomain != "www"
  end

  # ----------------------------------------------------
  # Audit logging
  # ----------------------------------------------------
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
    Rails.logger.error "Audit log failed: #{e.message}"
  end

  def filtered_params
    request.params.except(
      :controller,
      :action,
      :password,
      :password_confirmation
    )
  end
end
