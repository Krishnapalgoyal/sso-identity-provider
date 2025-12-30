# app/controllers/admin/audit_logs_controller.rb
module Admin
  class AuditLogsController < BaseController
    def index
      @audit_logs = AuditLog.all

      # Search query
      if params[:query].present?
        if AuditLog.respond_to?(:search)
          @audit_logs = AuditLog.search(
            params[:query],
            fields: [:action, :resource_type, :user_email],
            page: params[:page],
            per_page: 50
          )
        else
          @audit_logs = @audit_logs.where(
            'action ILIKE :q OR resource_type ILIKE :q',
            q: "%#{params[:query]}%"
          )
        end
      end

      # Filter by action
      @audit_logs = @audit_logs.where(action: params[:action_filter]) if params[:action_filter].present?
      # Filter by user
      @audit_logs = @audit_logs.where(user_id: params[:user_id]) if params[:user_id].present?
      # Filter by date range
      @audit_logs = @audit_logs.where('created_at >= ?', Date.parse(params[:start_date])) if params[:start_date].present?
      @audit_logs = @audit_logs.where('created_at <= ?', Date.parse(params[:end_date])) if params[:end_date].present?

      # Order & paginate
      @audit_logs = @audit_logs.order(created_at: :desc).page(params[:page]).per(50)
    end


    def show
      @audit_log = AuditLog.find(params[:id])
    end

    def export
      @audit_logs = AuditLog.recent.limit(10000)
      
      respond_to do |format|
        format.csv do
          send_data generate_csv(@audit_logs), 
                    filename: "audit_logs_#{Date.today}.csv"
        end
        format.json do
          render json: @audit_logs
        end
      end
    end

    private

    def generate_csv(logs)
      CSV.generate(headers: true) do |csv|
        csv << ['Timestamp', 'Action', 'User', 'Resource', 'IP Address', 'Metadata']
        
        logs.each do |log|
          csv << [
            log.created_at,
            log.action,
            log.user&.email,
            "#{log.resource_type}##{log.resource_id}",
            log.ip_address,
            log.metadata.to_json
          ]
        end
      end
    end
  end
end