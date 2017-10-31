class ContributedSessionsController < ConferenceSessionsController

  # see all
  def index
    @contributed_sessions = ContributedSession.includes(:schedules)
  end

  def new
    @conference_session = ContributedSession.new
  end

  def create 
    @conference_session = ContributedSession.new(conference_session_params)
    if @conference_session.save 
      redirect_to @conference_session, notice: 'The session has been created.'
    else
      render action: :new
    end
  end

  private

  # see ConferenceSessionsController
  def conference_session_params
    params[:contributed_session].permit(:name, :description)
  end
end

