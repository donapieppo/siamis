class MinitutorialsController < ConferenceSessionsController
  before_action :user_in_organizer_committee!, except: [:index, :show]

  def index 
    @minitutorials = Minitutorial.includes(:schedules, presentation: [authors: :user], organizers: :user)
  end

  def new
    @conference_session = Minitutorial.new
  end

  def create 
    @conference_session = Minitutorial.new(conference_session_params)
    if @conference_session.save 
      redirect_to @conference_session, notice: 'The conference_session has been created.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:minitutorial].permit(:name, :description)
  end
end


