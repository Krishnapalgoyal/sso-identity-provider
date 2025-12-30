module Admin
  class ServiceProvidersController < BaseController
    before_action :set_service_provider, only: [:show, :edit, :update, :destroy, :toggle_status]

    def index
      @service_providers = ServiceProvider.all.page(params[:page]).per(20)

      if params[:query].present?
        query = "%#{params[:query]}%"
        @service_providers = @service_providers.where('name ILIKE ? OR entity_id ILIKE ?', query, query)
      end
    end

    def show
      # Use resource_type + resource_id for audit logs
      @recent_authentications = AuditLog
        .where(resource_type: 'ServiceProvider', resource_id: @service_provider.id)
        .where(action: 'saml_sso')
        .recent
        .limit(50)
    end

    def new
      @service_provider = ServiceProvider.new
    end

    def create
      @service_provider = ServiceProvider.new(service_provider_params)
      if @service_provider.save
        log_audit('service_provider_created', @service_provider)
        redirect_to admin_service_provider_path(@service_provider), notice: 'Service Provider created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @service_provider.update(service_provider_params)
        log_audit('service_provider_updated', @service_provider, changes: @service_provider.previous_changes)
        redirect_to admin_service_provider_path(@service_provider), notice: 'Service Provider updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      name = @service_provider.name
      @service_provider.destroy
      log_audit('service_provider_deleted', nil, name: name)
      redirect_to admin_service_providers_path, notice: 'Service Provider deleted successfully.'
    end

    def toggle_status
      @service_provider.update!(active: !@service_provider.active)
      log_audit('service_provider_status_changed', @service_provider, active: @service_provider.active)
      redirect_to admin_service_provider_path(@service_provider),
                  notice: "Service Provider #{@service_provider.active? ? 'activated' : 'deactivated'}."
    end

    private

    def set_service_provider
      @service_provider = ServiceProvider.find(params[:id])
    end

    def service_provider_params
      params.require(:service_provider).permit(:name, :entity_id, :acs_url, :metadata_url, :certificate, :active)
    end

    def log_audit(action, resource = nil, metadata = {})
      AuditLog.log_action(
        action,
        user: current_user,
        resource: resource,
        metadata: metadata,
        ip: request.remote_ip
      )
    end
  end
end
