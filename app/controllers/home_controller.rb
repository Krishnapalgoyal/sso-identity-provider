class HomeController < ApplicationController
  def index
    if user_signed_in?
      @organization = current_organization
      @user = current_user
    end
  end
end
