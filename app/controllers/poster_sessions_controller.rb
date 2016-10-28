class PosterSessionsController < SessionsController
  def new
    @session = PosterSession.new
  end

  def create 
    @session = PosterSession.new(session_params)
    if @session.save 
      @session.organizers.create!(user: current_user)
      redirect_to @session, notice: 'The session has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @session.update_attributes(session_params)
      redirect_to @session, notice: 'The session has been updated.'
    else
      render action: :edit
    end
  end

  private

  def session_params
    params[:poster_session].permit(:name, :description)
  end
end


