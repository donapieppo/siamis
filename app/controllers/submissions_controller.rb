class SubmissionsController < ApplicationController
  def index
    if user_in_organizer_commettee?
      @minisymposia  = Minisymposium.includes(ratings: :user, organizers: :user).all
      @presentations = Presentation.unassigned.submitted.includes(ratings: :user, authors: :user).not_poster
      @posters       = Presentation.unassigned.submitted.includes(ratings: :user, authors: :user).poster
    else
      @minisymposia  = current_user.minisymposia.includes(organizers: :user).all
      @presentations = current_user.presentations.includes(authors: :user).all
    end
  end
end
