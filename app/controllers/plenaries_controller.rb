class PlenariesController < ConferenceSessionsController
  before_action :user_in_organizer_commettee!, except: [:index, :show]

  def index
    @plenaries = Plenary.includes(schedule: :room, presentation: [authors: :user], chairs: :user).order('schedules.start').all
  end

  def new 
    @conference_session = Plenary.new
  end

  def create 
    @conference_session = Plenary.new(conference_session_params)
    if @conference_session.save 
      redirect_to @conference_session, notice: 'The Plenary Invited Session has been created.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:plenary].permit(:name, :description)
  end
end
