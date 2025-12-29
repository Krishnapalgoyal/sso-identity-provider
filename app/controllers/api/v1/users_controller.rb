# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < BaseController
      def index
        @users = User.all
        render json: @users
      end

      def show
        @user = User.find(params[:id])
        render json: @user
      end

      def create
        @user = User.new(user_params)
        @user.password = SecureRandom.hex(10) if @user.password.blank?
        
        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def update
        @user = User.find(params[:id])
        
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, 
                 status: :unprocessable_entity
        end
      end

      def destroy
        @user = User.find(params[:id])
        @user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(
          :email, :first_name, :last_name, :role, :password
        )
      end
    end
  end
end