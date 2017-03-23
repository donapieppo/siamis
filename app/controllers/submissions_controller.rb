class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!

  # all minisymposia
  # presentations only unaccepted
  def index
    if current_user and user_in_organizer_committee?
      @minisymposia  = params[:minisymposium] ? Minisymposium.includes(:schedule, ratings: :user, organizers: :user) : nil
      @unassigned_presentations = params[:contributed] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).unassigned.not_poster : nil
      @posters       = params[:poster] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).unassigned.poster : nil
    elsif current_user
      @minisymposia  = current_user.minisymposia.includes(organizers: :user)
      @presentations = current_user.presentations.includes(authors: :user)
    end
  end
end
