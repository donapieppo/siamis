class ConferenceBreaksController < ConferenceSessionsController
  before_action :user_in_organizer_committee!, except: [:index, :show]

  def index
    @conference_sessions = ConferenceBreak.all
  end

  def new 
    @conference_session = ConferenceBreak.new
  end

  def create 
    @conference_session = ConferenceBreak.new(conference_session_params)
    if @conference_session.save 
      redirect_to conference_breaks_path
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:conference_break].permit(:name, :description)
  end
end

