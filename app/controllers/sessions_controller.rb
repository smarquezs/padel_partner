class SessionsController < ApplicationController
  def new
    redirect_to dashboard_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email]&.downcase)
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully!"
      redirect_to dashboard_path
    else
      flash.now[:error] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully!"
    redirect_to login_path
  end
end
