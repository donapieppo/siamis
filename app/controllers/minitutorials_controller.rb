class MinitutorialsController < ConferenceSessionsController
  # before_action :force_sso_user, except: :index
  # before_action :set_minitutorial_and_check_permission, only: [:edit, :update]

  # def show
  #   @minitutorial  = Minitutorial.find(params[:id])
  #   @presentations = @minitutorial.presentations.includes(authors: :user).all
  # end

  def new
    @conference_session = Minitutorial.new
  end

  def create 
    @conference_session = Minitutorial.new(minitutorial_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
      redirect_to @conference_session, notice: 'The conference_session has been created.'
    else
      render action: :new
    end
  end

  # def edit
  # end

  def update
    if @conference_session.update_attributes(minitutorial_params)
      redirect_to @conference_session, notice: 'The conference_session has been updated.'
    else
      render action: :edit
    end
  end

  private

  # fixme in realta' no
  def minitutorial_params
    params[:minitutorial].permit(:name, :description)
  end
end


