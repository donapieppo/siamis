class ContributedSessionsController < ConferenceSessionsController
  # before_action :force_sso_user, except: :index
  # before_action :set_contributred_conference_session_and_check_permission, only: [:edit, :update]

  # def index
  #   @contributed_conference_sessions = ContributedConferenceSession.includes(:schedule)
  # end

  # def show
  #   @contributed_conference_session = ContributedConferenceSession.find(params[:id])
  #   @presentations = @contributed_conference_session.presentations.includes(authors: :user)
  #   # includes(authors: :user, conference_session: [organizers: :user]).all
  # end

  def new
    @conference_session = ContributedConferenceSession.new
  end

  def create 
    @contributed_conference_session = ContributedConferenceSession.new(contributed_conference_session_params)
    if @contributed_conference_session.save 
      redirect_to contributed_conference_session_path(@contributed_conference_session), notice: 'The contributed_conference_session has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @contributed_conference_session.update_attributes(contributed_conference_session_params)
      redirect_to @contributed_conference_session, notice: 'The contributed_conference_session has been updated.'
    else
      render action: :edit
    end
  end

  private

  def contributed_conference_session_params
    params[:contributed_conference_session].permit(:name, :description)
  end

  def set_contributred_conference_session_and_check_permission
    @contributed_conference_session = ContributedConferenceSession.find(params[:id])
    current_user.owns!(@contributed_conference_session)
  end
end

