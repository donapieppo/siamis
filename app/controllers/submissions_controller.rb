class SubmissionsController < ApplicationController
  def index
    if user_in_organizer_commettee?
      @minisymposia  = Minisymposium.submitted.all
      @presentations = Presentation.unassigned.submitted.not_poster
      @posters       = Presentation.submitted.poster
    else
      @minisymposia  = current_user.minisymposia.all
      @presentations = current_user.presentations.all
    end
  end
end
