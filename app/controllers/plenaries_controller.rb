class PlenariesController < ConferenceSessionsController
  before_action :user_in_organizer_committee!, except: [:index, :show]

  def index
    @plenaries = Plenary.includes(schedules: :room, presentation: [authors: :user], organizers: :user).order('schedules.start, users.surname').all
  end

  def new 
    @conference_session = Plenary.new
  end

  def create 
    @conference_session = Plenary.new(conference_session_params)
    if @conference_session.save 
      redirect_to new_presentation_author_path(@conference_session.presentation), notice: 'The Plenary Session has been created. Please provide authors and chairs.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:plenary].permit(:name, :description, :number)
  end
end
