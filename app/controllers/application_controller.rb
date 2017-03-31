class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include UserHelper

  # helper_method :current_user_owns?, :current_user_owns!, :true_user_can_impersonate?, :user_in_organizer_committee?, :user_in_scientific_committee?

  before_action :change_date, :authenticate_user!, :log_current_user, :check_user_fields, :set_registration

  impersonates :user

  def change_date
    #if Rails.env.development?
    #  new_time = Time.local(2017, 9, 27, 12, 0, 0)
    #  Timecop.travel(new_time)
    #end
  end

  def log_current_user
    current_user or return true
    if current_user != true_user
      logger.info("#{true_user.email} IMPERSONATING #{current_user.email}")
    else
      logger.info("Current user: #{current_user.email}")
    end
  end

  def set_registration
    (@conference_registration ||= current_user.conference_registration) if current_user
  end

  def check_user_fields
    if current_user and (current_user.name.blank? or current_user.surname.blank?)
      redirect_to edit_user_path(current_user), notice: 'Please update your personal data.'
    end
  end

  def set_conference_session
    param_id = params[:minisymposium_id] || params[:minitutorial_id] || params[:plenary_id] || params[:contributed_session_id] || params[:conference_session_id] 
    @conference_session = ConferenceSession.find(param_id)
  end
end
