# app/controllers/admin/service_providers_controller.rb
module Admin
  class ServiceProvidersController < BaseController
    before_action :set_service_provider, only: [:show, :edit, :update, :destroy, :toggle_status]

    def index
      @service_providers = ServiceProvider.all.page(params[:page]).per(20)
      
      if params[:query].present?
        @service_providers = @service_providers.where(
          'name ILIKE ? OR entity_id ILIKE ?', 
          "%#{params[:query]}%", 
          "%#{params[:query]}%"
        )
      end
    end

    def show
      @recent_authentications = AuditLog
        .where(resource: @service_provider)
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
        AuditLog.log_action(
          'service_provider_created',
          user: current_user,
          resource: @service_provider,
          metadata: { name: @service_provider.name },
          ip: request.remote_ip
        )
        
        redirect_to admin_service_provider_path(@service_provider), 
                    notice: 'Service Provider created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @service_provider.update(service_provider_params)
        AuditLog.log_action(
          'service_provider_updated',
          user: current_user,
          resource: @service_provider,
          metadata: { changes: @service_provider.previous_changes },
          ip: request.remote_ip
        )
        
        redirect_to admin_service_provider_path(@service_provider), 
                    notice: 'Service Provider updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      name = @service_provider.name
      @service_provider.destroy
      
      AuditLog.log_action(
        'service_provider_deleted',
        user: current_user,
        metadata: { name: name },
        ip: request.remote_ip
      )
      
      redirect_to admin_service_providers_path, 
                  notice: 'Service Provider deleted successfully.'
    end

    def toggle_status
      @service_provider.update!(active: !@service_provider.active)
      
      AuditLog.log_action(
        'service_provider_status_changed',
        user: current_user,
        resource: @service_provider,
        metadata: { active: @service_provider.active },
        ip: request.remote_ip
      )
      
      redirect_to admin_service_provider_path(@service_provider), 
                  notice: "Service Provider #{@service_provider.active? ? 'activated' : 'deactivated'}."
    end

    private

    def set_service_provider
      @service_provider = ServiceProvider.find(params[:id])
    end

    def service_provider_params
      params.require(:service_provider).permit(
        :name, :entity_id, :acs_url, :metadata_url, :certificate, :active
      )
    end
  end
end