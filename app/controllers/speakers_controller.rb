class SpeakersController < RolesController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial_and_presentation, only: [:new, :create]

  def new
    @speaker = Speaker.new
  end

  def create
    @speaker = @presentation.speakers.new(roles_params)
    
    if @speaker.save
      redirect_to [:edit, (@presentation.minitutorial || @presentation.minisymposium)], notice: 'OK'
    else
      render action: :new
    end
  end

end

