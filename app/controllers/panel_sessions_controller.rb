class PanelSessionsController < ConferenceSessionsController
  before_action :user_in_organizer_committee!, except: [:index, :show]

  def index
    @conference_sessions = PanelSession.all
  end

  def new 
    @conference_session = PanelSession.new
  end

  def create 
    @conference_session = PanelSession.new(conference_session_params)
    if @conference_session.save 
      redirect_to new_presentation_author_path(@conference_session.presentation), notice: 'The Panel Session has been created. Please provide authors and chairs.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:panel_session].permit(:name, :description)
  end
end
