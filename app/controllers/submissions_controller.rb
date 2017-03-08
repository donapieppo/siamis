class SubmissionsController < ApplicationController
  def index
    if user_in_organizer_committee?
      @minisymposia  = params[:minisymposium] ? Minisymposium.includes(ratings: :user, organizers: :user).all : []
      @presentations = params[:contributed] ? Presentation.unassigned.includes(ratings: :user, authors: :user).not_poster.all : []
      @posters       = params[:poster] ? Presentation.unassigned.includes(ratings: :user, authors: :user).poster.all : []
    else
      @minisymposia  = current_user.minisymposia.includes(organizers: :user).all
      @presentations = current_user.presentations.includes(authors: :user).all
    end
  end
end
