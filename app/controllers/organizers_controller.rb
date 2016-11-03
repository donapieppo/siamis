class OrganizersController < RolesController
  before_action :set_minisymosium_and_minitutorial_and_presentation, only: [:new, :create]

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(roles_params)
    
    if @organizer.save
      redirect_to @conference_session, notice: 'OK'
    else
      render action: :new
    end
  end

end

