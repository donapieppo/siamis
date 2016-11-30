class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_owns?, :current_user_owns!, :true_user_can_impersonate?, :user_in_organizer_commettee?, :user_in_scientific_commettee?

  before_action :change_date, :authenticate_user!, :log_current_user, :check_user_fields, :check_registration

  impersonates :user

  def change_date
    if Rails.env.development?
      new_time = Time.local(2017, 8, 1, 12, 0, 0)
      Timecop.travel(new_time)
    end
  end

  def log_current_user
    current_user or return true
    logger.info("Current user: #{current_user.email}")
  end

  def check_registration
    current_user or return true
    @conference_registration ||= current_user.conference_registration
  end

  def check_user_fields
    if current_user and (current_user.name.blank? or current_user.surname.blank?)
      redirect_to edit_user_path(current_user), notice: 'Please update your personal data.'
    end
  end

  def user_master_of_universe?
    current_user and current_user.master_of_universe?
  end

  def user_master_of_universe!
    user_master_of_universe? or raise NoAccess
  end

  def user_in_organizer_commettee?
    current_user and current_user.in_organizer_commettee?
  end

  def user_in_organizer_commettee!
    user_in_organizer_commettee? or raise NoAccess
  end

  def user_in_scientific_commettee?
    current_user and current_user.in_scientific_committee?
  end

  def user_in_scientific_commettee!
    user_in_scientific_commettee? or raise NoAccess
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

  def set_conference_session
    param_id = params[:minisymposium_id] || params[:minitutorial_id] || params[:plenary_id]
    @conference_session = ConferenceSession.find(param_id)
  end
end
