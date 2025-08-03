class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)
    if user
      user.generate_password_reset_token
      UserMailer.password_reset(user).deliver_now
    end
    
    # Always show success message for security (don't reveal if email exists)
    flash[:notice] = "Email sent with password reset instructions"
    redirect_to login_path
  end

  def edit
  end

  def update
    if @user.update(password_params)
      @user.clear_password_reset_token
      flash[:notice] = "Password has been reset"
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def get_user
    @user = User.find_by(password_reset_token: params[:id])
  end

  def valid_user
    unless @user
      flash[:error] = "Invalid password reset link"
      redirect_to new_password_reset_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:error] = "Password reset has expired"
      redirect_to new_password_reset_path
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
