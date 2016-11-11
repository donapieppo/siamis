class ChairsController < RolesController
  before_action :set_minisymosium_and_minitutorial_and_presentation, only: [:new, :create]

  def new
    @role = Chair.new
    render 'roles/new'
  end

  def create
    @role = Chair.new(roles_params)
    if @role.save
      redirect_to @conference_session, notice: 'OK'
    else
      render action: :new
    end
  end

end

