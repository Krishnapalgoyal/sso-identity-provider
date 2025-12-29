# app/controllers/api/v1/info_controller.rb
module Api
  module V1
    class InfoController < BaseController
      skip_before_action :authenticate_api_request!
      
      def show
        render json: {
          api_version: 'v1',
          organization: current_organization&.name,
          endpoints: {
            service_providers: api_v1_service_providers_url,
            users: api_v1_users_url
          }
        }
      end
    end
  end
end