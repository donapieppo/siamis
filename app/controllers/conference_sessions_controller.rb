# not directly used but, for example, MinisymposiaController < ApplicationController 
# defines conference_session_params
class ConferenceSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_conference_session_and_check_permission, only: [:edit, :update, :manage_presentations, :ordering, :destroy]

  def index
  end

  def show
    @conference_session = ConferenceSession.includes(roles: :user).find(params[:id])
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
    @actual_presentations = @conference_session.presentations.includes([roles: :user]).order(:part, :number)
    @parts_number         = @conference_session.parts || 1
    if user_in_organizer_committee?
      @available_presentations = case @conference_session
                                 when PosterSession
                                   Presentation.unassigned.poster
                                 when ContributedSession
                                   Presentation.unassigned.not_poster
                                 else
                                   []
                                 end
    end
  end

  def ordering
    params[:order].each do |presentation_id, o|
      Presentation.find(presentation_id.to_i).update_attributes(o.permit(:part, :number))
    end
    redirect_to manage_presentations_conference_session_path(@conference_session)
  end

  # TODO
  def destroy
    @conference_session.destroy
    redirect_to root_path # FIXME
  end

  private

  def set_conference_session
    @conference_session = ConferenceSession.find(params[:id])
  end

  def set_conference_session_and_check_permission
    set_conference_session
    current_user.owns!(@conference_session)
  end
end

