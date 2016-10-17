class AuthorsController < RolesController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial_and_presentation, only: [:new, :create]

  def new
    @author = Author.new
  end

  def create
    @author = @presentation.authors.new(roles_params)
    
    if @author.save
      redirect_to @what, notice: 'OK'
    else
      render action: :new
    end
  end

end

