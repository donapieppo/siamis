class ContributedSessionsController < ApplicationController
  before_action :force_sso_user, except: :index
  before_action :set_contributred_session_and_check_permission, only: [:edit, :update]

  def index
  end

  def show
    @contributed_session = ContributedSession.find(params[:id])
    @presentations = @contributed_session.presentations.includes(authors: :user)
    # includes(authors: :user, session: [organizers: :user]).all
  end

  def new
    @contributed_session = ContributedSession.new
  end

  def create 
    @contributed_session = ContributedSession.new(contributed_session_params)
    if @contributed_session.save 
      redirect_to contributed_session_path(@contributed_session), notice: 'The contributed_session has been created.'
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @contributed_session.update_attributes(contributed_session_params)
      redirect_to @contributed_session, notice: 'The contributed_session has been updated.'
    else
      render action: :edit
    end
  end

  private

  def contributed_session_params
    params[:contributed_session].permit(:name, :description)
  end

  def set_contributred_session_and_check_permission
    @contributed_session = ContributedSession.find(params[:id])
    current_user.owns!(@contributed_session)
  end
end

