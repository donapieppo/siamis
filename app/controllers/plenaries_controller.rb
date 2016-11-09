class PlenariesController < ConferenceSessionsController
  def new 
    @conference_session = Plenary.new
  end

  def create 
    @conference_session = Plenary.new(conference_session_params)
    if @conference_session.save 
      redirect_to plenaries_path, notice: 'The Plenary Invited Session has been created.'
    else
      render action: :new
    end
  end

  private

  def conference_session_params
    params[:plenary].permit(:name, :description)
  end
end
