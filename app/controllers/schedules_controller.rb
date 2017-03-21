class SchedulesController < ApplicationController
  before_action :user_in_organizer_committee!, except: :index
  before_action :set_conference_session, only: [:new, :create, :update]

  def index
  end

  def new
    @schedule = @conference_session.schedule || @conference_session.build_schedule
  end

  def create
    @schedule = @conference_session.schedule || @conference_session.build_schedule
    if @schedule.update_attributes(schedule_params)
      redirect_to @conference_session, notice: 'OK'
    else
      render action: :new
    end
  end

  alias update create
    
  private

  def set_conference_session
    conference_session_id = params[:conference_session_id] || params[:contributed_session_id] || params[:minisymposium_id] || params[:minitutorial_id] || params[:poster_session_id] || params[:plenary_id]
    @conference_session  = ConferenceSession.find(conference_session_id)
  end

  def schedule_params
    # "start_day_number"=>"2", "start_hour"=>"09:15", "room_id"=>"1"
    start_day_number = params[:schedule].delete(:start_day_number)
    start_hour, start_min = params[:schedule].delete(:start_hour).split(':')
    start = (Rails.configuration.conference_start_date + start_day_number.to_i.days).to_datetime
    # FIXME with time zone!!!!!!!!!! -2
    params[:schedule][:start] = start.change(hour: start_hour.to_i - 2 , min: start_min.to_i)
    params[:schedule].permit(:start, :room_id)
  end
end

