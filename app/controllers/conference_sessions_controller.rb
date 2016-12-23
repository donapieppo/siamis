# not directly used but, for example, MinisymposiaController < ApplicationController 
# defines conference_session_params
class ConferenceSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_conference_session_and_check_permission, only: [:edit, :update, :manage_presentations, :destroy]

  def index
  end

  def show
    @conference_session = ConferenceSession.includes(schedule: :room, organizers: :user).find(params[:id])
  end

  def edit
  end

  def update
    if @conference_session.update_attributes(conference_session_params)
      redirect_to @conference_session, notice: 'The session has been updated.'
    else
      render action: :edit
    end
  end

  def manage_presentations
    @actual_presentations = @conference_session.presentations.order(:number)
    @available_presentations = case @conference_session
                               when PosterSession
                                 Presentation.unassigned.poster
                               when ContributedSession
                                 Presentation.unassigned.not_poster
                               else
                                 []
                               end
  end

  # TODO
  def destroy
    @conference_session.delete
    redirect_to root_path # FIXME
  end

  private

  def set_conference_session_and_check_permission
    @conference_session = ConferenceSession.find(params[:id])
    current_user.owns!(@conference_session)
  end
end

