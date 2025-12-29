# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :impersonate]

    def index
      @users = User.all.page(params[:page]).per(20)
      
      if params[:query].present?
        @users = @users.where(
          'email ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?',
          "%#{params[:query]}%",
          "%#{params[:query]}%",
          "%#{params[:query]}%"
        )
      end
      
      @users = @users.where(role: params[:role]) if params[:role].present?
    end

    def show
      @recent_activities = AuditLog
        .where(user: @user)
        .recent
        .limit(50)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.password = SecureRandom.hex(10) if @user.password.blank?
      
      if @user.save
        AuditLog.log_action(
          'user_created',
          user: current_user,
          resource: @user,
          metadata: { email: @user.email, role: @user.role },
          ip: request.remote_ip
        )
        
        redirect_to admin_user_path(@user), notice: 'User created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        AuditLog.log_action(
          'user_updated',
          user: current_user,
          resource: @user,
          metadata: { changes: @user.previous_changes },
          ip: request.remote_ip
        )
        
        redirect_to admin_user_path(@user), notice: 'User updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      email = @user.email
      @user.destroy
      
      AuditLog.log_action(
        'user_deleted',
        user: current_user,
        metadata: { email: email },
        ip: request.remote_ip
      )
      
      redirect_to admin_users_path, notice: 'User deleted successfully.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :email, :first_name, :last_name, :role, :password, :password_confirmation
      )
    end
  end
end