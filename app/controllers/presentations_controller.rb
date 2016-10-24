class PresentationsController < ApplicationController
  before_action :force_sso_user
  before_action :set_minisymosium_and_minitutorial_and_check_permission, only: [:new, :create]
  before_action :set_presentation_and_check_permission, only: [:edit, :update]

  def index
    @current_user_presentations = current_user.presentations.includes(authors: :user, session: [organizers: :user]).all
  end

  def show
    @presentation = Presentation.find(params[:id])
    @authors = @presentation.authors.includes(:user)
  end

  def new
    @presentation = Presentation.new
  end

  def create
    @presentation = @what ? @what.presentations.new(presentation_params) : Presentation.new(presentation_params)
    if @presentation.save
      # we are not authors
      if @what 
        redirect_to new_presentation_author_path(@presentation)
      # we are authors
      else
        @presentation.users << current_user
        redirect_to @presentation
      end
    else
      render action: :new
    end
  end

  def edit
  end

  def add
    @contributed_session = ContributedSession.find(params[:contributed_session_id])
    @presentation = Presentation.find(params[:id])
    @contributed_session.presentations << @presentation
    redirect_to @contributed_session
  end

  def remove
    @contributed_session = ContributedSession.find(params[:contributed_session_id])
    @presentation = Presentation.find(params[:id])
    @presentation.update_attribute(:session_id, nil)
    redirect_to @contributed_session
  end

  def update
    if @presentation.update_attributes(presentation_params)
      redirect_to @presentation, notice: 'OK'
    else
      render action: :edit
    end
  end

  def destroy
    @presentation = Presentation.find(params[:id])
    current_user.owns!(@presentation) or raise NOACCESS
    @presentation.delete
    redirect_to presentations_path
  end

  private

  def presentation_params
    params[:presentation].permit(:name, :abstract)
  end

  def set_minisymosium_and_minitutorial_and_check_permission
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
    @what = @minisymposium || @minitutorial
    current_user.owns!(@what) if @what
  end

  def set_presentation_and_check_permission
    @presentation = Presentation.find(params[:id])
    current_user.owns!(@presentation)
  end

end

