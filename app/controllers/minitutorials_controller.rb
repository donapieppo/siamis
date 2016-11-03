class MinitutorialsController < ConferenceSessionsController
  def new
    @conference_session = Minitutorial.new
  end

  def create 
    @conference_session = Minitutorial.new(conference_session_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
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


