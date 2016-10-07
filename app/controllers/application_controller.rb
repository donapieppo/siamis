class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :current_user_owns?, :current_user_owns!

  before_action :log_current_user, :force_sso_user

  def current_user
    return nil unless session[:user_id]
    (@current_user ||= User.find(session[:user_id])) if session[:user_id]
  end

  def log_current_user
    current_user or return true
    logger.info("Current user: #{current_user.email}")
  end

  # see Rails.configuration.dm_unibo_common[:omniauth_provider]
  # actually: shibboleth (for unibo) and google_oauth2
  # Use in app/controllers/application_controller.rb like
  # before_filter :log_current_user, :force_sso_user
  def force_sso_user
    if ! current_user
      session[:original_request] = request.fullpath
      redirect_to login_path and return 
    end
  end

  def redirect_unsigned_user
    if ! user_signed_in?
      redirect_to root_path, alert: "Si prega di loggarsi per accedere alla pagina richiesta."
      return
    end
  end

  def user_master_of_universe!
    (@current_user and @current_user.master_of_universe?) or raise NO_ACCESS
  end

  def current_user_owns?(what)
    current_user and current_user.owns?(what)
  end

  def current_user_owns!(what)
    current_user_owns?(what) or raise "NotAuthorized"
  end
end
