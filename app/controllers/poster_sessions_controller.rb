class PosterSessionsController < ConferenceSessionsController

  def index
    @poster_sessions = PosterSession.includes(:schedule).all
  end

  def new
    @conference_session = PosterSession.new
  end

  def create 
    @conference_session = PosterSession.new(conference_session_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
      redirect_to @conference_session, notice: 'The conference_session has been created.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:poster_session].permit(:name, :description)
  end
end


