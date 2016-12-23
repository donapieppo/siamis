class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UserHelper

  # helper_method :current_user_owns?, :current_user_owns!, :true_user_can_impersonate?, :user_in_organizer_commettee?, :user_in_scientific_commettee?

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

  def set_conference_session
    param_id = params[:minisymposium_id] || params[:minitutorial_id] || params[:plenary_id]
    @conference_session = ConferenceSession.find(param_id)
  end
end
