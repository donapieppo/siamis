class MinisymposiaController < ConferenceSessionsController
  # before_action :force_sso_user, except: :index
  # before_action :set_minisymposium_and_check_permission, only: [:edit, :update]

  # def index
  # end

  # def show
  #   @minisymposium = Minisymposium.includes(organizers: :user).find(params[:id])
  #   @presentations = @minisymposium.presentations.includes(authors: :user).all
  # end

  def new
    @conference_session = Minisymposium.new
  end

  def create 
    @conference_session = Minisymposium.new(minisymposium_params)
    if @conference_session.save 
      @conference_session.organizers.create!(user: current_user)
      redirect_to @conference_session, notice: 'The minisymposium has been created.'
    else
      render action: :new
    end
  end

  #def edit
  #end

  def update
    if @conference_session.update_attributes(minisymposium_params)
      redirect_to @conference_session, notice: 'The minisymposium has been updated.'
    else
      render action: :edit
    end
  end

  private

  def minisymposium_params
    params[:minisymposium].permit(:name, :description)
  end

  #def set_minisymposium_and_check_permission
  #  @minisymposium = Minisymposium.find(params[:id])
  #  current_user.owns!(@minisymposium)
  #end
end

