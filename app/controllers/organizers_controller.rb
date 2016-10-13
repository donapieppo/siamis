class OrganizersController < RolesController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial_and_presentation, only: [:new, :create]

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(roles_params)
    
    if @organizer.save
      redirect_to [:edit, @minitutorial || @minisymposium], notice: 'OK'
    else
      render action: :new
    end
  end

end

