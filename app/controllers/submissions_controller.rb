class SubmissionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :user_in_organizer_committee!, except: [:index]

  # all minisymposia
  # presentations only unaccepted
  def index
    @no_container = true
    if current_user
      @presentations = current_user.presentations.includes(:conference_session, authors: :user)
      @minisymposia  = current_user.minisymposia.includes(organizers: :user)
    end
  end

  def admin
    @minisymposia  = params[:minisymposium] ? Minisymposium.includes(:schedule, ratings: :user, organizers: :user).order('updated_at DESC')  : nil
    @unassigned_presentations = params[:contributed] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).unassigned.not_poster : nil
    @posters       = params[:poster] ? Presentation.includes(:conference_session, ratings: :user, authors: :user).unassigned.poster : nil
  end
end
