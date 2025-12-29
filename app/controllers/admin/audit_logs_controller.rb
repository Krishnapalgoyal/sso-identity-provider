# app/controllers/admin/audit_logs_controller.rb
module Admin
  class AuditLogsController < BaseController
    def index
      @audit_logs = if params[:query].present?
        # Use Searchkick if available
        if AuditLog.respond_to?(:search)
          AuditLog.search(
            params[:query],
            fields: [:action, :resource_type, :user_email],
            page: params[:page],
            per_page: 50
          )
        else
          # Fallback to SQL search
          AuditLog.where(
            'action ILIKE ? OR resource_type ILIKE ?',
            "%#{params[:query]}%",
            "%#{params[:query]}%"
          ).recent.page(params[:page]).per(50)
        end
      else
        AuditLog.recent.page(params[:page]).per(50)
      end
      
      # Filter by action
      @audit_logs = @audit_logs.where(action: params[:action]) if params[:action].present?
      
      # Filter by user
      @audit_logs = @audit_logs.where(user_id: params[:user_id]) if params[:user_id].present?
      
      # Filter by date range
      if params[:start_date].present?
        @audit_logs = @audit_logs.where('created_at >= ?', params[:start_date])
      end
      
      if params[:end_date].present?
        @audit_logs = @audit_logs.where('created_at <= ?', params[:end_date])
      end
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