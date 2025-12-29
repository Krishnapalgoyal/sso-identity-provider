# app/controllers/api/v1/service_providers_controller.rb
module Api
  module V1
    class ServiceProvidersController < BaseController
      def index
        @service_providers = ServiceProvider.all
        render json: @service_providers
      end

      def show
        @service_provider = ServiceProvider.find(params[:id])
        render json: @service_provider
      end

      def create
        @service_provider = ServiceProvider.new(service_provider_params)
        
        if @service_provider.save
          render json: @service_provider, status: :created
        else
          render json: { errors: @service_provider.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def update
        @service_provider = ServiceProvider.find(params[:id])
        
        if @service_provider.update(service_provider_params)
          render json: @service_provider
        else
          render json: { errors: @service_provider.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def destroy
        @service_provider = ServiceProvider.find(params[:id])
        @service_provider.destroy
        head :no_content
      end

      private

      def service_provider_params
        params.require(:service_provider).permit(
          :name, :entity_id, :acs_url, :metadata_url, :certificate, :active
        )
      end
    end
  end
end