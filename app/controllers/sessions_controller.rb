class SessionsController < ApplicationController
  before_action :force_sso_user, except: :index
  before_action :set_session_and_check_permission, only: [:edit, :update]

  def index
  end

  def show
    @session = Session.includes(organizers: :user).find(params[:id])
    @presentations = @session.presentations.includes(authors: :user).all
  end

  def edit
  end

  def update
    if @session.update_attributes(session_params)
      redirect_to @session, notice: 'The session has been updated.'
    else
      render action: :edit
    end
  end

  private

  def set_session_and_check_permission
    @session = Session.find(params[:id])
    current_user.owns!(@session)
  end
end

