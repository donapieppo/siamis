# only for logged user
# wiew all only throuh sessions
class PresentationsController < ApplicationController
  before_action :set_minisymosium_and_minitutorial_and_check_permission, only: [:new, :create]
  before_action :set_presentation_and_check_permission, only: [:edit, :update, :add, :remove]

  # like submissions (think, fixme)
  def index
    @current_user_presentations = current_user.presentations.includes(authors: :user, conference_session: [organizers: :user]).all
  end

  def show
    @presentation = Presentation.find(params[:id])
    @authors = @presentation.authors.includes(:user)
  end

  def new
    @presentation = Presentation.new(poster: params[:poster])
  end

  def create
    @presentation = @conference_session ? @conference_session.presentations.new(presentation_params) : Presentation.new(presentation_params)
    if @presentation.save
      # we are not authors
      if @conference_session 
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
    @contributed_session.presentations << @presentation
    redirect_to @contributed_session
  end

  def remove
    @contributed_session = ContributedSession.find(params[:contributed_session_id])
    @presentation.update_attribute(:conference_session_id, nil)
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
    params[:presentation].permit(:name, :abstract, :poster)
  end

  def set_minisymosium_and_minitutorial_and_check_permission
    @minisymposium = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @minitutorial  = Minitutorial.find(params[:minitutorial_id]) if params[:minitutorial_id]
    @conference_session = @minisymposium || @minitutorial
    current_user.owns!(@conference_session) if @conference_session
  end

  def set_presentation_and_check_permission
    @presentation = Presentation.find(params[:id])
    current_user.owns!(@presentation)
  end

end

