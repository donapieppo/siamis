class ChairsController < RolesController
  before_action :set_conference_session, only: [:new, :create]

  def new
    @role = Chair.new
    render 'roles/new'
  end

  def create
    @role = @conference_session.chairs.new(role_params)
    if @role.save
      redirect_to @conference_session, notice: 'OK'
    else
      render action: :new
    end
  end
end

