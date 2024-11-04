class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  before_action :require_login

  private

  def require_login
    return if controller_name == 'sessions' && (action_name == 'new' || action_name == 'create')
    return if controller_name == 'sessions' && action_name == 'destroy'
    return if controller_name == 'users' && action_name == 'new'

    unless current_user
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
