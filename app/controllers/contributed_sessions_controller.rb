class ContributedSessionsController < ConferenceSessionsController
  after_action :manual_tags, only: [:create, :update]

  # see all
  def index
    @conference_sessions = ContributedSession.includes(:schedules).order(:number)
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
    @manual_tags = params[:contributed_session].delete(:manual_tags)
    params[:contributed_session].permit(:name, :description, tag_ids: [])
  end

  def manual_tags  
    if @manual_tags
      @conference_session.manual_tags = @manual_tags
    end
  end
end

