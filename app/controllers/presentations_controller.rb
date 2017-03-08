# only for logged user
# wiew all only throuh sessions
class PresentationsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_conference_session_and_check_permission, only: [:new, :create]
  before_action :set_presentation_and_check_permission, only: [:edit, :update, :destroy, :set_number, :add, :remove, :accept, :refuse]
  before_action :check_deadline!, only: [:new, :create]
  before_action :user_in_organizer_commettee!, only: [:accept]

  # like submissions (think, fixme)
  def index
    if params[:user_id] and user_in_organizer_commettee?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    @presentations = @user.presentations.includes(authors: :user, conference_session: [organizers: :user]).all
  end

  def show
    @presentation = Presentation.find(params[:id])
    if @presentation.lonely_in_session?
      redirect_to @presentation.conference_session and return
    end
  end

  def new
    @presentation = Presentation.new(poster: params[:poster])
  end

  # if not in organizer_commettee you are the author
  def create
    @presentation = @conference_session ? @conference_session.presentations.new(presentation_params) : Presentation.new(presentation_params)
    if @presentation.save
      # we are not authors
      if @conference_session 
        redirect_to new_presentation_author_path(@presentation)
      # we are authors
      else
        @presentation.authors.create(user: current_user, speak: true) unless user_in_organizer_commettee?
        redirect_to @presentation
      end
    else
      render action: :new
    end
  end

  def edit
    if @presentation.conference_session and (@presentation.conference_session.is_a?(Minitutorial) or @presentation.conference_session.is_a?(Plenary))
      redirect_to [:edit, @presentation.conference_session] 
      return
    end
  end

  # only Organizer Commettee
  def add
    @conference_session = ConferenceSession.find(params[:conference_session_id])
    (@conference_session.presentations << @presentation) if user_in_organizer_commettee?
    redirect_to manage_presentations_conference_session_path(@conference_session)
  end

  # only Organizer Commettee (or else the presentation is orphaned)
  def remove
    @conference_session = ConferenceSession.find(params[:conference_session_id])
    (@presentation.update_attribute(:conference_session_id, nil)) if user_in_organizer_commettee?
    redirect_to manage_presentations_conference_session_path(@conference_session)
  end

  def update
    if @presentation.update_attributes(presentation_params)
      redirect_to @presentation, notice: 'OK'
    else
      render action: :edit
    end
  end

  def destroy
    conference_session = @presentation.conference_session
    @presentation.delete
    redirect_to (conference_session ? conference_session : presentations_path)
  end

  def accept
    @presentation.accept!
    redirect_to submissions_path((@presentation.poster ? :poster : :contributed) => 1), notice: 'The presentation has been accepted.'
  end

  # FiXME for now is just unaccept.
  def refuse
    @presentation.refuse!
    redirect_to submissions_path((@presentation.poster ? :poster : :contributed) => 1), notice: 'The presentation has been unaccepted.'
  end

  private

  def presentation_params
    params[:presentation].permit(:name, :abstract, :poster, :speaker_id)
  end

  def set_presentation 
    @presentation = Presentation.find(params[:id])
  end

  # A presentation can be created relative to a minitutorial or minisymosium
  # Otherwise is submitted by author and then Commettee assign it to PosterSession o ContributedSession
  def set_conference_session_and_check_permission
    @conference_session = Minisymposium.find(params[:minisymposium_id]) if params[:minisymposium_id]
    @conference_session = Minitutorial.find(params[:minitutorial_id])   if params[:minitutorial_id]
    @conference_session = ContributedSession.find(params[:contributed_session_id]) if params[:contributed_session_id]
    @conference_session = PosterSession.find(params[:poster_session_id]) if params[:poster_session_id]
    current_user.owns!(@conference_session) if @conference_session
  end

  def set_presentation_and_check_permission
    set_presentation
    current_user.owns!(@presentation)
  end

  def check_deadline!
    # FIXME
    # if conference_session can always add presentations
    @conference_session or Deadline.can_propose?(:presentation) or user_in_organizer_commettee? or raise ProposalClose
  end
end

