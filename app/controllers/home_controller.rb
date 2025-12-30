class HomeController < ApplicationController
  def index
    if user_signed_in?
      # Redirect admin or super_admin directly to admin dashboard
      if current_user.admin?
        redirect_to admin_root_path and return
      end

      # For normal users, load organization info
      @organization = current_organization
      @user = current_user
    end
  end
end
