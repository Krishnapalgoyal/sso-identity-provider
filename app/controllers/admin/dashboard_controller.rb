# app/controllers/admin/dashboard_controller.rb
module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        total_users: User.count,
        total_service_providers: ServiceProvider.count,
        active_service_providers: ServiceProvider.active.count,
        recent_logins: AuditLog.where(action: 'login').recent.limit(10),
        recent_activities: AuditLog.recent.limit(20)
      }
    end
  end
end