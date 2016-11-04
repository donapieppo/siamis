class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_owns?, :current_user_owns!, :true_user_can_impersonate?, :user_committee_organizer?

  before_action :authenticate_user!, :log_current_user, :check_user_fields, :check_registration
  before_action :configure_permitted_parameters, if: :devise_controller?

  impersonates :user

  def log_current_user
    current_user or return true
    logger.info("Current user: #{current_user.email}")
  end

  def check_registration
    current_user or return true
    @conference_registration ||= current_user.conference_registration
  end

  def check_user_fields
    current_user or return true
    if current_user.name.blank? or current_user.surname.blank?
      redirect_to edit_user_path(current_user)
    end
  end

  def user_master_of_universe?
    current_user and current_user.master_of_universe?
  end

  def user_master_of_universe!
    user_master_of_universe? or raise NO_ACCESS
  end

  def user_committee_organizer?
    current_user and current_user.committee_organizer?
  end

  def user_committee_organizer!
    user_committee_organizer? or raise NO_ACCESS
  end

  def current_user_owns?(what)
    current_user and current_user.owns?(what)
  end

  def current_user_owns!(what)
    current_user_owns?(what) or raise "NotAuthorized"
  end

  def true_user_can_impersonate?
    true_user and Rails.configuration.impersonate_admins and Rails.configuration.impersonate_admins.include?(true_user.email)
  end

  def set_minisymosium_and_minitutorial_and_presentation
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id])   if params[:minitutorial_id]
    @presentation  = Presentation.find(params[:presentation_id])   if params[:presentation_id]
    @conference_session = @minisymposium || @minitutorial || @presentation
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :affiliation])
  end
end
