class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # Renders the login form
  end

  def create
    username = params[:username].strip
    if username.blank? || username.length < 3
      flash[:alert] = "Username must be at least 3 characters."
      redirect_to login_path
      return
    end

    user = User.find_or_create_by(username: username)
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out successfully."
  end
end
