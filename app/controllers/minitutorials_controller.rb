class MinitutorialsController < SessionsController
  # before_action :force_sso_user, except: :index
  # before_action :set_minitutorial_and_check_permission, only: [:edit, :update]

  # def show
  #   @minitutorial  = Minitutorial.find(params[:id])
  #   @presentations = @minitutorial.presentations.includes(authors: :user).all
  # end

  def new
    @session = Minitutorial.new
  end

  def create 
    @session = Minitutorial.new(minitutorial_params)
    if @session.save 
      @session.organizers.create!(user: current_user)
      redirect_to @session, notice: 'The session has been created.'
    else
      render action: :new
    end
  end

  # def edit
  # end

  def update
    if @session.update_attributes(minitutorial_params)
      redirect_to @session, notice: 'The session has been updated.'
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


