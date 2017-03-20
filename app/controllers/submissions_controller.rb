class SubmissionsController < ApplicationController

  # all minisymposia
  # presentations only unaccepted
  def index
    if user_in_organizer_committee?
      @minisymposia  = params[:minisymposium] ? Minisymposium.includes(:schedule, ratings: :user, organizers: :user) : []
      @unassigned_presentations = params[:contributed] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).unassigned.not_poster : []
      @posters       = params[:poster] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).poster : []
    else
      @minisymposia  = current_user.minisymposia.includes(organizers: :user)
      @presentations = current_user.presentations.includes(authors: :user)
    end
  end
end
