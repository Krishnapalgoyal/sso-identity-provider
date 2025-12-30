class Users::RegistrationsController < Devise::RegistrationsController
  def create
    ActiveRecord::Base.transaction do
      org = Organization.create!(
        name: params[:organization][:name],
        subdomain: params[:organization][:subdomain]
      )

      build_resource(sign_up_params)
      resource.organization = org
      resource.role = "admin"
      resource.save!

      sign_up(resource_name, resource)
      redirect_to admin_root_url(subdomain: org.subdomain)
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.message
    render :new
  end
end
