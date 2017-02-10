class AuthorsController < RolesController
  before_action :set_presentation, only: [:new, :create]
  before_action :set_author_and_check_permission, only: [:make_speaker, :destroy]

  def new
    @role = Author.new
    render 'roles/new'
  end

  def create
    first = @presentation.authors.empty?
    @role = @presentation.authors.new(role_params)
    @role.speak = first
    if @role.save
      redirect_to @presentation, notice: 'OK'
    else
      render action: :new
    end
  end

  def destroy
    # FIXME not to destroy yourself
    if @author.user == current_user
      flash error: 'You can not delete yourself from authors of this presentation.'
    else
      @author.destroy
    end
    redirect_to @author.presentation, notice: 'OK'
  end

  def make_speaker
    @author.is_speaker!
    redirect_to [:edit, @author.presentation]
  end

  private

  def set_presentation
    @presentation  = Presentation.find(params[:presentation_id]) 
  end

  def set_author_and_check_permission
    @author = Author.find(params[:id])
    current_user.owns!(@author.presentation)
  end
end

